-- Consultas analíticas - FixPC (PostgreSQL)

-- 1. Resumo financeiro geral (apenas pagamentos aprovados)
SELECT
    COUNT(id) AS total_pagamentos_aprovados,
    ROUND(SUM(valor_bruto), 2) AS gmv_volume_bruto,
    ROUND(SUM(marketplace_fee), 2) AS receita_liquida_fixpc,
    ROUND(SUM(valor_tecnico), 2) AS repasse_total_tecnicos,
    ROUND(AVG(valor_bruto), 2) AS ticket_medio_atendimento
FROM transacoes
WHERE status = 'approved';


-- 2. Faturamento mensal e variação percentual em relação ao mês anterior (MoM)
WITH receita_mensal AS (
    SELECT
        DATE_TRUNC('month', aprovado_em)::DATE AS mes_referencia,
        COUNT(id) AS qtd_atendimentos_pagos,
        SUM(valor_bruto) AS faturamento_bruto,
        SUM(marketplace_fee) AS receita_plataforma
    FROM transacoes
    WHERE status = 'approved'
    GROUP BY 1
)
SELECT
    TO_CHAR(mes_referencia, 'YYYY-MM') AS ano_mes,
    qtd_atendimentos_pagos,
    ROUND(faturamento_bruto, 2) AS faturamento_bruto,
    ROUND(receita_plataforma, 2) AS receita_plataforma,
    ROUND(
        ((faturamento_bruto - LAG(faturamento_bruto) OVER (ORDER BY mes_referencia))
        / NULLIF(LAG(faturamento_bruto) OVER (ORDER BY mes_referencia), 0)) * 100,
    2) AS crescimento_mom_percentual
FROM receita_mensal
ORDER BY mes_referencia;


-- 3. Ranking de técnicos por faturamento e nota média (CTEs separadas para não duplicar linhas no join)
WITH financeiro_tecnico AS (
    SELECT
        tecnico_id,
        COUNT(DISTINCT chamado_id) AS chamados_pagos,
        SUM(valor_bruto) AS volume_gerado,
        SUM(valor_tecnico) AS ganho_liquido_tecnico
    FROM transacoes
    WHERE status = 'approved'
    GROUP BY tecnico_id
),
qualidade_tecnico AS (
    SELECT
        avaliado_id AS tecnico_id,
        COUNT(id) AS total_avaliacoes,
        ROUND(AVG(nota), 2) AS nota_media
    FROM avaliacoes
    WHERE tipo = 'cliente_para_tecnico'
    GROUP BY avaliado_id
)
SELECT
    RANK() OVER (ORDER BY COALESCE(f.volume_gerado, 0) DESC, COALESCE(q.nota_media, 0) DESC) AS ranking,
    u.name AS tecnico,
    u.status AS status_cadastro,
    COALESCE(f.chamados_pagos, 0) AS atendimentos_pagos,
    ROUND(COALESCE(f.volume_gerado, 0), 2) AS volume_bruto_gerado,
    ROUND(COALESCE(f.ganho_liquido_tecnico, 0), 2) AS ganho_liquido_tecnico,
    COALESCE(q.total_avaliacoes, 0) AS qtd_avaliacoes,
    COALESCE(q.nota_media, 0.00) AS nota_media_clientes
FROM users u
LEFT JOIN financeiro_tecnico f ON u.id = f.tecnico_id
LEFT JOIN qualidade_tecnico q ON u.id = q.tecnico_id
WHERE u.role = 'tecnico'
ORDER BY ranking;


-- 4. Volume de chamados, ticket médio e tempo médio de sessão remota (min) por categoria
SELECT
    c.categoria,
    COUNT(c.id) AS total_chamados,
    COUNT(c.id) FILTER (WHERE c.status = 'fechado') AS chamados_concluidos,
    ROUND(AVG(t.valor_bruto), 2) AS ticket_medio,
    ROUND(AVG(EXTRACT(EPOCH FROM (sr.encerrada_em - sr.iniciada_em)) / 60.0), 1) AS tempo_medio_sessao_minutos
FROM chamados c
LEFT JOIN transacoes t
    ON c.id = t.chamado_id AND t.status = 'approved'
LEFT JOIN sessoes_remotas sr
    ON c.id = sr.chamado_id AND sr.status = 'encerrada'
GROUP BY c.categoria
ORDER BY total_chamados DESC;


-- 5. Funil de conversão dos chamados
SELECT
    COUNT(DISTINCT c.id) AS etapa_1_chamados_abertos,
    COUNT(DISTINCT p.chamado_id) AS etapa_2_com_proposta,
    COUNT(DISTINCT p.chamado_id) FILTER (WHERE p.status = 'aceita') AS etapa_3_proposta_aceita,
    COUNT(DISTINCT t.chamado_id) FILTER (WHERE t.status = 'approved') AS etapa_4_pagamento_aprovado,
    COUNT(DISTINCT c.id) FILTER (WHERE c.status = 'fechado') AS etapa_5_concluidos,
    ROUND(
        (COUNT(DISTINCT t.chamado_id) FILTER (WHERE t.status = 'approved')::NUMERIC
        / NULLIF(COUNT(DISTINCT c.id), 0)) * 100,
    1) AS taxa_conversao_pagamento_pct
FROM chamados c
LEFT JOIN propostas p ON c.id = p.chamado_id
LEFT JOIN transacoes t ON c.id = t.chamado_id;


-- 6. Taxa de aprovação e volume por meio de pagamento
SELECT
    CASE
        WHEN metodo = 'pix' THEN 'PIX'
        ELSE 'Cartão de Crédito (' || UPPER(metodo) || ')'
    END AS meio_pagamento,
    COUNT(id) AS tentativas_totais,
    COUNT(id) FILTER (WHERE status = 'approved') AS aprovadas,
    COUNT(id) FILTER (WHERE status = 'rejected') AS recusadas,
    ROUND(
        (COUNT(id) FILTER (WHERE status = 'approved')::NUMERIC / NULLIF(COUNT(id), 0)) * 100,
    1) AS taxa_aprovacao_pct,
    ROUND(SUM(valor_bruto) FILTER (WHERE status = 'approved'), 2) AS volume_aprovado
FROM transacoes
GROUP BY 1
ORDER BY volume_aprovado DESC NULLS LAST;


-- 7. Recorrência e gasto total (LTV) por cliente
SELECT
    u.name AS cliente,
    SPLIT_PART(u.endereco, ' - ', 2) AS cidade_uf,
    COUNT(DISTINCT c.id) AS total_chamados_abertos,
    CASE
        WHEN COUNT(DISTINCT c.id) > 1 THEN 'Recorrente'
        ELSE 'Atendimento Único'
    END AS perfil_retencao,
    ROUND(COALESCE(SUM(t.valor_bruto), 0), 2) AS ltv_gasto_total
FROM users u
INNER JOIN chamados c ON u.id = c.cliente_id
LEFT JOIN transacoes t ON c.id = t.chamado_id AND t.status = 'approved'
WHERE u.role = 'cliente'
GROUP BY u.id, u.name, u.endereco
ORDER BY ltv_gasto_total DESC, total_chamados_abertos DESC;


-- 8. Chamados abertos ou em andamento com agente RustDesk offline
SELECT
    c.id AS chamado_id,
    c.status AS status_chamado,
    c.titulo,
    u.name AS cliente,
    u.celular,
    a.rustdesk_id,
    a.status AS status_agente,
    a.ultimo_contato_em
FROM chamados c
INNER JOIN users u ON c.cliente_id = u.id
LEFT JOIN agentes a ON u.id = a.user_id
WHERE c.status IN ('aberto', 'em andamento')
  AND (a.status = 'offline' OR a.status IS NULL)
ORDER BY c.aberto_em;
