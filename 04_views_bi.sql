[engine]
default = "nim"

[engine.ollama]
host = "http://localhost:11434"

[intelligence]
default_model = "google/gemma-4-31b-it"

[agent]
default_agent = "react"
max_turns = 10
-- Camada de Views analíticas para consumo no Power BI (FixPC)

CREATE OR REPLACE VIEW vw_chamados_analitico AS
SELECT
    c.id AS chamado_id,
    c.titulo,
    c.categoria,
    c.status AS status_chamado,
    c.aberto_em::DATE AS data_abertura,
    DATE_TRUNC('month', c.aberto_em)::DATE AS mes_abertura,
    c.fechado_em::DATE AS data_fechamento,
    cli.name AS cliente_nome,
    SPLIT_PART(cli.endereco, ' - ', 2) AS cliente_cidade,
    COALESCE(tec.name, 'Sem técnico') AS tecnico_nome,
    ROUND(EXTRACT(EPOCH FROM (sr.encerrada_em - sr.iniciada_em)) / 60.0, 1) AS duracao_sessao_min,
    COALESCE(t.valor_bruto, 0) AS valor_bruto,
    COALESCE(t.marketplace_fee, 0) AS receita_fixpc,
    COALESCE(t.valor_tecnico, 0) AS repasse_tecnico,
    av.nota AS nota_cliente
FROM chamados c
INNER JOIN users cli ON c.cliente_id = cli.id
LEFT JOIN users tec ON c.tecnico_id = tec.id
LEFT JOIN sessoes_remotas sr ON c.id = sr.chamado_id AND sr.status = 'encerrada'
LEFT JOIN transacoes t ON c.id = t.chamado_id AND t.status = 'approved'
LEFT JOIN avaliacoes av ON c.id = av.chamado_id AND av.tipo = 'cliente_para_tecnico';

CREATE OR REPLACE VIEW vw_transacoes_analitico AS
SELECT
    t.id AS transacao_id,
    t.chamado_id,
    c.categoria,
    CASE
        WHEN t.metodo = 'pix' THEN 'PIX'
        ELSE 'Cartão (' || UPPER(t.metodo) || ')'
    END AS meio_pagamento,
    t.status AS status_pagamento,
    t.valor_bruto,
    t.marketplace_fee AS receita_fixpc,
    t.valor_tecnico,
    t.created_at::DATE AS data_tentativa,
    t.aprovado_em::DATE AS data_aprovacao,
    DATE_TRUNC('month', COALESCE(t.aprovado_em, t.created_at))::DATE AS mes_referencia
FROM transacoes t
INNER JOIN chamados c ON t.chamado_id = c.id;

CREATE OR REPLACE VIEW vw_ranking_tecnicos AS
WITH financeiro AS (
    SELECT
        tecnico_id,
        COUNT(DISTINCT chamado_id) AS atendimentos_pagos,
        SUM(valor_bruto) AS volume_gerado,
        SUM(valor_tecnico) AS ganho_liquido
    FROM transacoes
    WHERE status = 'approved'
    GROUP BY tecnico_id
),
avaliacao AS (
    SELECT
        avaliado_id AS tecnico_id,
        COUNT(id) AS qtd_avaliacoes,
        ROUND(AVG(nota), 2) AS nota_media
    FROM avaliacoes
    WHERE tipo = 'cliente_para_tecnico'
    GROUP BY avaliado_id
)
SELECT
    u.id AS tecnico_id,
    u.name AS tecnico_nome,
    u.status AS status_cadastro,
    COALESCE(f.atendimentos_pagos, 0) AS atendimentos_pagos,
    COALESCE(f.volume_gerado, 0) AS volume_gerado,
    COALESCE(f.ganho_liquido, 0) AS ganho_liquido,
    COALESCE(a.qtd_avaliacoes, 0) AS qtd_avaliacoes,
    COALESCE(a.nota_media, 0) AS nota_media
FROM users u
LEFT JOIN financeiro f ON u.id = f.tecnico_id
LEFT JOIN avaliacao a ON u.id = a.tecnico_id
WHERE u.role = 'tecnico';
[tools]
enabled = ["web_search", "think", "file_read", "code_interpreter", "http_request"]

[tools.web_search]
provider = "duckduckgo"
max_results = 5

[analytics]
enabled = false
choice_recorded = true