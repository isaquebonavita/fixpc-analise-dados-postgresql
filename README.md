# fixpc-analise-dados-postgresql
Modelagem relacional em PostgreSQL, massa de dados fictícios e consultas SQL analíticas baseadas na operação da plataforma FixPC.

# FixPC — Banco de Dados e Análise SQL (PostgreSQL)

Modelagem relacional e consultas analíticas extraídas da estrutura do **FixPC**, plataforma de suporte técnico remoto onde clientes abrem chamados, técnicos enviam propostas e o atendimento acontece via RustDesk com pagamento integrado (split Mercado Pago).

Como o código-fonte da aplicação web/mobile fica em repositório privado, reuni aqui a estrutura do banco em PostgreSQL, uma massa de dados fictícios para testes e as queries que montei para acompanhar os indicadores da operação.

## Arquivos

- `01_schema_fixpc.sql` — 11 tabelas principais (`users`, `chamados`, `propostas`, `transacoes`, `sessoes_remotas`, `avaliacoes`, etc.), chaves estrangeiras, constraints e índices.
- `02_seed_fixpc.sql` — Dados fictícios simulando o fluxo real: chamados abertos, em andamento e fechados, split financeiro (15% comissão da plataforma / 85% técnico), pagamentos aprovados e recusados e sessões remotas.
- `03_analises_negocio.sql` — Queries de análise utilizando CTEs, Window Functions (`LAG`, `RANK`), cálculo de duração de sessão e agregações condicionais (`FILTER`).

## Indicadores cobertos nas consultas

1. **Financeiro:** GMV, receita líquida da plataforma, repasse aos técnicos e ticket médio.
2. **Evolução mensal (MoM):** Comparativo de faturamento mês a mês.
3. **Performance dos técnicos:** Volume financeiro gerado cruzado com a média das avaliações.
4. **SLA e categorias:** Problemas mais frequentes e tempo médio de duração das sessões remotas.
5. **Funil de conversão:** Taxa de passagem desde a abertura do chamado até o pagamento aprovado.
6. **Pagamentos e retenção:** Aprovação por meio de pagamento (PIX vs. cartão), LTV por cliente e monitoramento de agentes offline.
