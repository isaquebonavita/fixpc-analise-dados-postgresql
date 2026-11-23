# FixPC — Banco de Dados e Análise SQL (PostgreSQL)

Modelagem relacional e consultas analíticas extraídas da estrutura do FixPC, plataforma de suporte técnico remoto onde clientes abrem chamados, técnicos enviam propostas e o atendimento acontece via RustDesk com pagamento integrado (split Mercado Pago).

Como o código-fonte da aplicação web/mobile fica em repositório privado, reuni aqui a estrutura do banco em PostgreSQL, uma massa de dados fictícios para testes e as queries que montei para acompanhar os indicadores da operação.

## Arquivos

Scripts organizados na ordem de execução no PostgreSQL:

- `01_schema_fixpc.sql` — 11 tabelas principais (`users`, `chamados`, `propostas`, `transacoes`, `sessoes_remotas`, `avaliacoes`, etc.), chaves estrangeiras, constraints e índices.
- `02_seed_fixpc.sql` — Dados fictícios simulando o fluxo real: chamados abertos, em andamento e fechados, split financeiro (15% comissão da plataforma / 85% técnico), pagamentos aprovados e recusados e sessões remotas.
- `03_analises_negocio.sql` — Queries de análise usando CTEs, Window Functions (`LAG`, `RANK`), cálculo de duração de sessão e agregações condicionais (`FILTER`).

## O que as consultas analisam

- Resumo financeiro geral (GMV, receita líquida da plataforma, repasse aos técnicos e ticket médio)
- Evolução mensal de faturamento (MoM)
- Ranking de técnicos cruzando volume financeiro gerado e nota média das avaliações
- Demanda, ticket médio e tempo médio de sessão remota (SLA) por categoria de problema
- Funil de conversão desde a abertura do chamado até o pagamento aprovado
- Taxa de aprovação por meio de pagamento (PIX vs. cartão), recorrência/LTV por cliente e monitoramento de agentes offline
