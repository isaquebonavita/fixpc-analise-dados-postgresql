-- Estrutura do banco FixPC (PostgreSQL)
-- Modelo relacional consolidado para análise de dados e indicadores do marketplace

DROP TABLE IF EXISTS activity_logs CASCADE;
DROP TABLE IF EXISTS avaliacoes CASCADE;
DROP TABLE IF EXISTS sessao_eventos CASCADE;
DROP TABLE IF EXISTS sessoes_remotas CASCADE;
DROP TABLE IF EXISTS transacoes CASCADE;
DROP TABLE IF EXISTS propostas CASCADE;
DROP TABLE IF EXISTS chamado_atribuicoes CASCADE;
DROP TABLE IF EXISTS chamados CASCADE;
DROP TABLE IF EXISTS agentes CASCADE;
DROP TABLE IF EXISTS tecnico_mp CASCADE;
DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    email_verified_at TIMESTAMP NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(30) NOT NULL DEFAULT 'cliente',
    status VARCHAR(30) NOT NULL DEFAULT 'pendente',
    bloqueado_em TIMESTAMP NULL,
    cpf VARCHAR(14) UNIQUE NULL,
    celular VARCHAR(20) NULL,
    nascimento DATE NULL,
    endereco VARCHAR(255) NULL,
    cep VARCHAR(10) NULL,
    avatar VARCHAR(255) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tecnico_mp (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    mp_user_id VARCHAR(100) NULL,
    access_token TEXT NOT NULL,
    refresh_token TEXT NULL,
    public_key VARCHAR(255) NULL,
    scope TEXT NULL,
    expires_at TIMESTAMP NULL,
    conectado_em TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE agentes (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    rustdesk_id VARCHAR(100) NULL,
    agent_key_hash VARCHAR(64) UNIQUE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'offline',
    ultimo_contato_em TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE chamados (
    id BIGSERIAL PRIMARY KEY,
    tecnico_id BIGINT NULL REFERENCES users(id),
    cliente_id BIGINT NOT NULL REFERENCES users(id),
    titulo VARCHAR(255) NOT NULL,
    descricao TEXT NOT NULL,
    imagens JSONB NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'aberto',
    categoria VARCHAR(100) NOT NULL,
    id_atendimento VARCHAR(100) NULL,
    aberto_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fechado_em TIMESTAMP NULL,
    tecnico_confirmou BOOLEAN NOT NULL DEFAULT FALSE,
    cliente_confirmou BOOLEAN NOT NULL DEFAULT FALSE,
    tecnico_confirmou_em TIMESTAMP NULL,
    cliente_confirmou_em TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE chamado_atribuicoes (
    id BIGSERIAL PRIMARY KEY,
    chamado_id BIGINT NOT NULL REFERENCES chamados(id) ON DELETE CASCADE,
    tecnico_id BIGINT NOT NULL REFERENCES users(id),
    atribuido_por_id BIGINT NULL REFERENCES users(id),
    motivo TEXT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE propostas (
    id BIGSERIAL PRIMARY KEY,
    chamado_id BIGINT NOT NULL REFERENCES chamados(id) ON DELETE CASCADE,
    tecnico_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    preco NUMERIC(10, 2) NOT NULL,
    mensagem TEXT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pendente' CHECK (status IN ('pendente', 'aceita', 'rejeitada')),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (chamado_id, tecnico_id)
);

CREATE TABLE transacoes (
    id BIGSERIAL PRIMARY KEY,
    chamado_id BIGINT NOT NULL REFERENCES chamados(id) ON DELETE CASCADE,
    proposta_id BIGINT NULL REFERENCES propostas(id) ON DELETE SET NULL,
    tecnico_id BIGINT NOT NULL REFERENCES users(id),
    cliente_id BIGINT NOT NULL REFERENCES users(id),
    mp_preference_id VARCHAR(255) NULL,
    mp_payment_id VARCHAR(255) NULL,
    metodo VARCHAR(50) NULL,
    valor_bruto NUMERIC(10, 2) NOT NULL,
    marketplace_fee NUMERIC(10, 2) NOT NULL DEFAULT 0,
    valor_tecnico NUMERIC(10, 2) NOT NULL DEFAULT 0,
    status VARCHAR(30) NOT NULL DEFAULT 'pending',
    status_detail VARCHAR(255) NULL,
    aprovado_em TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sessoes_remotas (
    id BIGSERIAL PRIMARY KEY,
    chamado_id BIGINT NOT NULL REFERENCES chamados(id) ON DELETE CASCADE,
    token UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    credencial_cifrada TEXT NULL,
    token_expira_em TIMESTAMP NULL,
    token_usado_em TIMESTAMP NULL,
    log_token UUID NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'aguardando',
    iniciada_em TIMESTAMP NULL,
    encerrada_em TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sessao_eventos (
    id BIGSERIAL PRIMARY KEY,
    sessao_remota_id BIGINT NOT NULL REFERENCES sessoes_remotas(id) ON DELETE CASCADE,
    origem VARCHAR(20) NOT NULL,
    tipo VARCHAR(40) NOT NULL,
    payload JSONB NULL,
    ts TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE avaliacoes (
    id BIGSERIAL PRIMARY KEY,
    chamado_id BIGINT NOT NULL REFERENCES chamados(id) ON DELETE CASCADE,
    avaliador_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    avaliado_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    nota SMALLINT NOT NULL CHECK (nota BETWEEN 1 AND 5),
    comentario TEXT NULL,
    tipo VARCHAR(40) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (chamado_id, avaliador_id)
);

CREATE TABLE activity_logs (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NULL,
    acao VARCHAR(60) NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    alvo_tipo VARCHAR(40) NULL,
    alvo_id BIGINT NULL,
    ip VARCHAR(45) NULL,
    created_at TIMESTAMP NULL
);

CREATE INDEX idx_chamados_status ON chamados(status);
CREATE INDEX idx_chamados_categoria ON chamados(categoria);
CREATE INDEX idx_chamados_aberto_em ON chamados(aberto_em);
CREATE INDEX idx_transacoes_status ON transacoes(status);
CREATE INDEX idx_transacoes_chamado_proposta ON transacoes(chamado_id, proposta_id);
CREATE INDEX idx_avaliacoes_avaliado ON avaliacoes(avaliado_id);
