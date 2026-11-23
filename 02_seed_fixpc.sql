-- Carga de dados fictícios para testes e consultas analíticas (FixPC)

-- Usuários (admin, técnicos e clientes)
INSERT INTO users (id, name, email, password, role, status, bloqueado_em, cpf, celular, nascimento, endereco, cep, created_at) VALUES
(1,  'Admin FixPC',         'admin@fixpc.com.br',       'hash_admin', 'admin',   'aprovado', NULL, '111.111.111-01', '(15) 99100-0001', '1995-03-10', 'Rua Quintino Bocaiúva, 120 - Itapetininga/SP', '18200-014', '2026-07-01 09:00:00'),
(2,  'Rafael Silva',        'rafael.tec@email.com',     'hash_tec2',  'tecnico', 'aprovado', NULL, '222.222.222-02', '(15) 99100-0002', '1994-06-15', 'Av. Peixoto Gomide, 450 - Itapetininga/SP',    '18200-000', '2026-07-05 10:15:00'),
(3,  'Mariana Costa',       'mariana.tec@email.com',    'hash_tec3',  'tecnico', 'aprovado', NULL, '333.333.333-03', '(15) 99100-0003', '1997-11-22', 'Rua Barão de Cotegipe, 310 - Sorocaba/SP',     '18010-120', '2026-07-08 14:20:00'),
(4,  'Lucas Oliveira',      'lucas.tec@email.com',      'hash_tec4',  'tecnico', 'aprovado', NULL, '444.444.444-04', '(15) 99100-0004', '1992-01-30', 'Rua Cesário Mota, 88 - Itapetininga/SP',       '18200-080', '2026-07-12 11:00:00'),
(5,  'Bruno Almeida',       'bruno.tec@email.com',      'hash_tec5',  'tecnico', 'pendente', NULL, '555.555.555-05', '(15) 99100-0005', '1999-08-19', 'Rua 15 de Novembro, 512 - Tatuí/SP',           '18270-000', '2026-10-15 16:40:00'),
(6,  'Carlos Mendes',       'carlos.cli@email.com',     'hash_cli6',  'cliente', 'aprovado', NULL, '666.666.666-06', '(15) 99200-0006', '1985-04-12', 'Rua Campos Salles, 200 - Itapetininga/SP',     '18200-060', '2026-08-01 08:30:00'),
(7,  'Fernanda Rocha',      'fernanda.cli@email.com',   'hash_cli7',  'cliente', 'aprovado', NULL, '777.777.777-07', '(15) 99200-0007', '1990-09-25', 'Av. Antônio Carlos Comitre, 900 - Sorocaba/SP','18047-620', '2026-08-03 13:10:00'),
(8,  'João Pedro Souza',    'joaopedro.cli@email.com',  'hash_cli8',  'cliente', 'aprovado', NULL, '888.888.888-08', '(15) 99200-0008', '1978-12-05', 'Rua Venâncio Aires, 640 - Itapetininga/SP',    '18200-050', '2026-08-10 17:45:00'),
(9,  'Beatriz Lima',        'beatriz.cli@email.com',    'hash_cli9',  'cliente', 'aprovado', NULL, '999.999.999-09', '(15) 99200-0009', '1996-02-18', 'Rua São Bento, 145 - Sorocaba/SP',             '18010-030', '2026-08-18 10:05:00'),
(10, 'Roberto Alves',       'roberto.cli@email.com',    'hash_cli10', 'cliente', 'aprovado', NULL, '101.101.101-10', '(15) 99200-0010', '1982-07-07', 'Rua Alfredo Maia, 330 - Itapetininga/SP',      '18200-110', '2026-09-02 15:20:00'),
(11, 'Patrícia Gomes',      'patricia.cli@email.com',   'hash_cli11', 'cliente', 'aprovado', NULL, '121.121.121-11', '(15) 99200-0011', '1989-05-14', 'Av. General Carneiro, 1120 - Sorocaba/SP',     '18043-002', '2026-09-14 09:50:00'),
(12, 'Thiago Martins',      'thiago.cli@email.com',     'hash_cli12', 'cliente', 'aprovado', NULL, '131.131.131-12', '(15) 99200-0012', '1993-10-29', 'Rua Prudente de Moraes, 77 - Itapetininga/SP', '18200-030', '2026-10-01 11:30:00');

-- Contas Mercado Pago dos técnicos
INSERT INTO tecnico_mp (user_id, mp_user_id, access_token, scope, conectado_em) VALUES
(2, 'MP_900102', 'enc_token_rafael',  'read write offline_access', '2026-07-06 11:00:00'),
(3, 'MP_900103', 'enc_token_mariana', 'read write offline_access', '2026-07-09 09:30:00'),
(4, 'MP_900104', 'enc_token_lucas',   'read write offline_access', '2026-07-13 15:45:00');

-- Agentes RustDesk nos clientes
INSERT INTO agentes (user_id, rustdesk_id, agent_key_hash, status, ultimo_contato_em) VALUES
(6,  '148290311', 'sha256_cli6',  'online',  '2026-11-21 13:50:00'),
(7,  '294810224', 'sha256_cli7',  'offline', '2026-11-20 18:10:00'),
(8,  '384729105', 'sha256_cli8',  'online',  '2026-11-21 14:00:00'),
(9,  '491028374', 'sha256_cli9',  'offline', '2026-11-18 11:20:00'),
(10, '582910473', 'sha256_cli10', 'online',  '2026-11-21 12:30:00'),
(11, '673829104', 'sha256_cli11', 'online',  '2026-11-21 14:05:00'),
(12, '764910283', 'sha256_cli12', 'online',  '2026-11-21 13:15:00');

-- Chamados
INSERT INTO chamados (id, tecnico_id, cliente_id, titulo, descricao, status, categoria, id_atendimento, aberto_em, fechado_em, tecnico_confirmou, cliente_confirmou, tecnico_confirmou_em, cliente_confirmou_em) VALUES
(1,  2, 6,  'Notebook travando muito ao abrir navegador',       'Windows 11 demorando 5 minutos para iniciar e disco em 100%.',           'fechado',      'Otimização e Lentidão',         'ATD-001', '2026-08-05 09:00:00', '2026-08-05 11:30:00', TRUE,  TRUE,  '2026-08-05 11:25:00', '2026-08-05 11:30:00'),
(2,  3, 7,  'Pop-ups suspeitos e navegador redirecionando',     'Aparecendo propagandas mesmo com navegador fechado.',                      'fechado',      'Remoção de Vírus e Malware',    'ATD-002', '2026-08-14 14:00:00', '2026-08-14 16:15:00', TRUE,  TRUE,  '2026-08-14 16:10:00', '2026-08-14 16:15:00'),
(3,  2, 8,  'Impressora Epson L3250 não imprime via Wi-Fi',     'Driver desapareceu após atualização do Windows.',                         'fechado',      'Configuração de Rede e Impressora', 'ATD-003', '2026-08-22 10:15:00', '2026-08-22 11:45:00', TRUE,  TRUE,  '2026-08-22 11:40:00', '2026-08-22 11:45:00'),
(4,  4, 9,  'Tela azul frequente (CRITICAL_PROCESS_DIED)',       'PC reiniciando sozinho durante reuniões no Teams.',                      'fechado',      'Erro de Sistema / Tela Azul',   'ATD-004', '2026-09-04 15:00:00', '2026-09-04 18:20:00', TRUE,  TRUE,  '2026-09-04 18:10:00', '2026-09-04 18:20:00'),
(5,  3, 6,  'Configurar backup automático em nuvem e Office',   'Preciso organizar pastas da empresa no OneDrive e ativar pacote Office.', 'fechado',      'Formatação e Backup',           'ATD-005', '2026-09-12 09:30:00', '2026-09-12 11:20:00', TRUE,  TRUE,  '2026-09-12 11:15:00', '2026-09-12 11:20:00'),
(6,  2, 10, 'Remoção de ransomware/adware pesado',              'Arquivos com extensão estranha na pasta Downloads e CPU no máximo.',     'fechado',      'Remoção de Vírus e Malware',    'ATD-006', '2026-09-25 13:20:00', '2026-09-25 16:40:00', TRUE,  TRUE,  '2026-09-25 16:30:00', '2026-09-25 16:40:00'),
(7,  4, 11, 'PC gamer com queda brusca de FPS e aquecimento',   'Limpeza de processos em segundo plano e ajuste de drivers NVIDIA.',      'fechado',      'Otimização e Lentidão',         'ATD-007', '2026-10-03 16:00:00', '2026-10-03 18:00:00', TRUE,  TRUE,  '2026-10-03 17:55:00', '2026-10-03 18:00:00'),
(8,  3, 7,  'Compartilhamento de pasta na rede do escritório',  'Dois computadores não enxergam o servidor de arquivos local.',           'fechado',      'Configuração de Rede e Impressora', 'ATD-008', '2026-10-14 10:00:00', '2026-10-14 12:10:00', TRUE,  TRUE,  '2026-10-14 12:00:00', '2026-10-14 12:10:00'),
(9,  2, 12, 'Backup completo antes de reinstalar sistema',      'Salvar 180GB de fotos e documentos e otimizar instalação limpa.',        'fechado',      'Formatação e Backup',           'ATD-009', '2026-10-28 08:45:00', '2026-10-28 12:30:00', TRUE,  TRUE,  '2026-10-28 12:20:00', '2026-10-28 12:30:00'),
(10, 3, 8,  'Erro ao atualizar Windows Update (0x80070002)',    'Atualização falha toda noite e reverte alterações.',                     'fechado',      'Erro de Sistema / Tela Azul',   'ATD-010', '2026-11-06 14:10:00', '2026-11-06 16:05:00', TRUE,  TRUE,  '2026-11-06 16:00:00', '2026-11-06 16:05:00'),
(11, 2, 10, 'Lentidão extrema no sistema ERP da loja',          'Banco local travando e consumo excessivo de memória RAM.',              'em andamento', 'Otimização e Lentidão',         'ATD-011', '2026-11-18 09:15:00', NULL,                  FALSE, FALSE, NULL,                  NULL),
(12, 4, 11, 'Suspeita de invasão e troca de senhas',          'E-mail enviando spam sozinho, preciso varredura completa.',              'em andamento', 'Remoção de Vírus e Malware',    'ATD-012', '2026-11-20 15:30:00', NULL,                  FALSE, FALSE, NULL,                  NULL),
(13, NULL, 9, 'Instalar impressora térmica Elgin i9',           'Configurar impressão de etiquetas no sistema de vendas.',                'aberto',       'Configuração de Rede e Impressora', NULL,      '2026-11-21 09:00:00', NULL,                  FALSE, FALSE, NULL,                  NULL),
(14, NULL, 12,'PC desligando ao abrir AutoCAD',                 'Possível conflito de driver de vídeo ou energia.',                       'aberto',       'Erro de Sistema / Tela Azul',   NULL,      '2026-11-21 10:40:00', NULL,                  FALSE, FALSE, NULL,                  NULL),
(15, NULL, 6, 'Organização de backup em HD externo',            'Configurar rotina semanal automática de cópia de segurança.',            'aberto',       'Formatação e Backup',           NULL,      '2026-11-21 13:30:00', NULL,                  FALSE, FALSE, NULL,                  NULL);

-- Histórico de atribuições
INSERT INTO chamado_atribuicoes (chamado_id, tecnico_id, atribuido_por_id, motivo, created_at) VALUES
(1,  2, 6, 'Proposta aceita pelo cliente', '2026-08-05 09:20:00'),
(2,  3, 7, 'Proposta aceita pelo cliente', '2026-08-14 14:25:00'),
(3,  2, 8, 'Proposta aceita pelo cliente', '2026-08-22 10:30:00'),
(4,  4, 9, 'Proposta aceita pelo cliente', '2026-09-04 15:30:00'),
(5,  3, 6, 'Proposta aceita pelo cliente', '2026-09-12 09:50:00'),
(6,  2, 10,'Proposta aceita pelo cliente', '2026-09-25 13:50:00'),
(7,  4, 11,'Proposta aceita pelo cliente', '2026-10-03 16:20:00'),
(8,  3, 7, 'Proposta aceita pelo cliente', '2026-10-14 10:20:00'),
(9,  2, 12,'Proposta aceita pelo cliente', '2026-10-28 09:10:00'),
(10, 3, 8, 'Proposta aceita pelo cliente', '2026-11-06 14:30:00'),
(11, 2, 10,'Proposta aceita pelo cliente', '2026-11-18 09:40:00'),
(12, 4, 11,'Proposta aceita pelo cliente', '2026-11-20 16:00:00');

-- Propostas
INSERT INTO propostas (id, chamado_id, tecnico_id, preco, mensagem, status, created_at) VALUES
(1,  1,  2, 90.00,  'Faço limpeza completa de inicialização e otimização.',      'aceita',    '2026-08-05 09:10:00'),
(2,  1,  3, 110.00, 'Otimização avançada e verificação de saúde do SSD.',         'rejeitada', '2026-08-05 09:12:00'),
(3,  2,  3, 120.00, 'Varredura profunda anti-malware e limpeza de navegadores.',  'aceita',    '2026-08-14 14:15:00'),
(4,  2,  4, 100.00, 'Remoção de adwares e bloqueio de extensões maliciosas.',     'rejeitada', '2026-08-14 14:18:00'),
(5,  3,  2, 75.00,  'Reinstalação limpa do driver Epson e fixação de IP na rede.','aceita',    '2026-08-22 10:22:00'),
(6,  4,  4, 150.00, 'Análise de dump de memória, reparo de sistema e drivers.',   'aceita',    '2026-09-04 15:15:00'),
(7,  4,  2, 165.00, 'Diagnóstico completo de tela azul e estabilidade.',          'rejeitada', '2026-09-04 15:20:00'),
(8,  5,  3, 110.00, 'Configuração do OneDrive e ativação do pacote Office.',      'aceita',    '2026-09-12 09:40:00'),
(9,  6,  2, 180.00, 'Remoção completa de infecção e blindagem do sistema.',       'aceita',    '2026-09-25 13:35:00'),
(10, 6,  3, 195.00, 'Desinfecção profunda e auditoria de processos.',             'rejeitada', '2026-09-25 13:40:00'),
(11, 7,  4, 130.00, 'Ajuste fino de GPU, energia e processos em segundo plano.',  'aceita',    '2026-10-03 16:10:00'),
(12, 8,  3, 95.00,  'Ajuste de permissões SMB e mapeamento de rede local.',       'aceita',    '2026-10-14 10:12:00'),
(13, 8,  2, 85.00,  'Configuração rápida de compartilhamento Windows.',           'rejeitada', '2026-10-14 10:14:00'),
(14, 9,  2, 160.00, 'Backup estruturado com verificação de integridade.',         'aceita',    '2026-10-28 08:55:00'),
(15, 10, 3, 105.00, 'Reparo de componentes do Windows Update via DISM/SFC.',      'aceita',    '2026-11-06 14:20:00'),
(16, 11, 2, 140.00, 'Otimização de memória e serviços do ERP.',                   'aceita',    '2026-11-18 09:25:00'),
(17, 11, 4, 150.00, 'Análise de gargalo de disco e RAM.',                         'rejeitada', '2026-11-18 09:30:00'),
(18, 12, 4, 175.00, 'Auditoria de segurança, remoção de malware e hardering.',    'aceita',    '2026-11-20 15:45:00'),
(19, 13, 2, 80.00,  'Instalação e teste de impressão da Elgin i9.',               'pendente',  '2026-11-21 09:20:00'),
(20, 13, 3, 85.00,  'Configuração de spooler e layout de etiquetas.',             'pendente',  '2026-11-21 09:35:00'),
(21, 14, 4, 135.00, 'Diagnóstico de driver gráfico e perfil de energia.',         'pendente',  '2026-11-21 11:00:00');

-- Transações (split 15% FixPC / 85% técnico)
INSERT INTO transacoes (chamado_id, proposta_id, tecnico_id, cliente_id, mp_payment_id, metodo, valor_bruto, marketplace_fee, valor_tecnico, status, status_detail, aprovado_em, created_at) VALUES
(1,  1,  2, 6,  'MP_PAY_1001', 'pix',    90.00,  13.50, 76.50,  'approved', 'accredited',           '2026-08-05 09:22:00', '2026-08-05 09:21:00'),
(2,  3,  3, 7,  'MP_PAY_1002', 'master', 120.00, 18.00, 102.00, 'approved', 'accredited',           '2026-08-14 14:28:00', '2026-08-14 14:26:00'),
(3,  5,  2, 8,  'MP_PAY_1003', 'pix',    75.00,  11.25, 63.75,  'approved', 'accredited',           '2026-08-22 10:32:00', '2026-08-22 10:31:00'),
(4,  6,  4, 9,  'MP_PAY_1004', 'visa',   150.00, 22.50, 127.50, 'rejected', 'cc_rejected_insufficient_amount', NULL, '2026-09-04 15:31:00'),
(4,  6,  4, 9,  'MP_PAY_1005', 'pix',    150.00, 22.50, 127.50, 'approved', 'accredited',           '2026-09-04 15:34:00', '2026-09-04 15:33:00'),
(5,  8,  3, 6,  'MP_PAY_1006', 'pix',    110.00, 16.50, 93.50,  'approved', 'accredited',           '2026-09-12 09:52:00', '2026-09-12 09:51:00'),
(6,  9,  2, 10, 'MP_PAY_1007', 'master', 180.00, 27.00, 153.00, 'approved', 'accredited',           '2026-09-25 13:53:00', '2026-09-25 13:51:00'),
(7,  11, 4, 11, 'MP_PAY_1008', 'pix',    130.00, 19.50, 110.50, 'approved', 'accredited',           '2026-10-03 16:22:00', '2026-10-03 16:21:00'),
(8,  12, 3, 7,  'MP_PAY_1009', 'visa',   95.00,  14.25, 80.75,  'approved', 'accredited',           '2026-10-14 10:23:00', '2026-10-14 10:21:00'),
(9,  14, 2, 12, 'MP_PAY_1010', 'pix',    160.00, 24.00, 136.00, 'approved', 'accredited',           '2026-10-28 09:12:00', '2026-10-28 09:11:00'),
(10, 15, 3, 8,  'MP_PAY_1011', 'pix',    105.00, 15.75, 89.25,  'approved', 'accredited',           '2026-11-06 14:32:00', '2026-11-06 14:31:00'),
(11, 16, 2, 10, 'MP_PAY_1012', 'master', 140.00, 21.00, 119.00, 'approved', 'accredited',           '2026-11-18 09:43:00', '2026-11-18 09:41:00'),
(12, 18, 4, 11, 'MP_PAY_1013', 'pix',    175.00, 26.25, 148.75, 'approved', 'accredited',           '2026-11-20 16:02:00', '2026-11-20 16:01:00');

-- Sessões remotas
INSERT INTO sessoes_remotas (chamado_id, status, iniciada_em, encerrada_em, created_at) VALUES
(1,  'encerrada', '2026-08-05 09:30:00', '2026-08-05 11:15:00', '2026-08-05 09:25:00'),
(2,  'encerrada', '2026-08-14 14:35:00', '2026-08-14 16:05:00', '2026-08-14 14:30:00'),
(3,  'encerrada', '2026-08-22 10:40:00', '2026-08-22 11:30:00', '2026-08-22 10:35:00'),
(4,  'encerrada', '2026-09-04 15:45:00', '2026-09-04 18:00:00', '2026-09-04 15:40:00'),
(5,  'encerrada', '2026-09-12 10:00:00', '2026-09-12 11:10:00', '2026-09-12 09:55:00'),
(6,  'encerrada', '2026-09-25 14:00:00', '2026-09-25 16:20:00', '2026-09-25 13:55:00'),
(7,  'encerrada', '2026-10-03 16:30:00', '2026-10-03 17:50:00', '2026-10-03 16:25:00'),
(8,  'encerrada', '2026-10-14 10:30:00', '2026-10-14 11:55:00', '2026-10-14 10:25:00'),
(9,  'encerrada', '2026-10-28 09:20:00', '2026-10-28 12:10:00', '2026-10-28 09:15:00'),
(10, 'encerrada', '2026-11-06 14:40:00', '2026-11-06 15:55:00', '2026-11-06 14:35:00'),
(11, 'ativa',     '2026-11-18 10:00:00', NULL,                  '2026-11-18 09:50:00'),
(12, 'ativa',     '2026-11-20 16:15:00', NULL,                  '2026-11-20 16:05:00');

-- Avaliações
INSERT INTO avaliacoes (chamado_id, avaliador_id, avaliado_id, nota, comentario, tipo, created_at) VALUES
(1,  6,  2, 5, 'Excelente atendimento, notebook ficou muito rápido.',       'cliente_para_tecnico', '2026-08-05 11:35:00'),
(1,  2,  6, 5, 'Cliente atencioso e acompanhou todo o processo.',           'tecnico_para_cliente', '2026-08-05 11:36:00'),
(2,  7,  3, 5, 'Resolveu os vírus rapidamente e explicou como evitar.',     'cliente_para_tecnico', '2026-08-14 16:20:00'),
(3,  8,  2, 4, 'Impressora voltou a funcionar perfeitamente.',              'cliente_para_tecnico', '2026-08-22 11:50:00'),
(4,  9,  4, 5, 'Salvou meu trabalho, nenhuma tela azul desde então.',       'cliente_para_tecnico', '2026-09-04 18:25:00'),
(5,  6,  3, 5, 'Tudo organizado na nuvem, recomendo.',                      'cliente_para_tecnico', '2026-09-12 11:25:00'),
(6,  10, 2, 5, 'Atendimento técnico de altíssimo nível.',                   'cliente_para_tecnico', '2026-09-25 16:45:00'),
(7,  11, 4, 4, 'Melhorou bastante a temperatura e estabilidade.',           'cliente_para_tecnico', '2026-10-03 18:05:00'),
(8,  7,  3, 5, 'Rede funcionando entre todos os PCs.',                      'cliente_para_tecnico', '2026-10-14 12:15:00'),
(9,  12, 2, 5, 'Backup feito com muito cuidado, zero perda de dados.',      'cliente_para_tecnico', '2026-10-28 12:35:00'),
(10, 8,  3, 4, 'Problema do Windows Update corrigido.',                     'cliente_para_tecnico', '2026-11-06 16:10:00');

SELECT setval('users_id_seq', (SELECT MAX(id) FROM users));
SELECT setval('chamados_id_seq', (SELECT MAX(id) FROM chamados));
SELECT setval('propostas_id_seq', (SELECT MAX(id) FROM propostas));
