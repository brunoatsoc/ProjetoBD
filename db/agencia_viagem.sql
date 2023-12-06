CREATE DATABASE agencia_viagem;

USE agencia_viagem;

CREATE TABLE CLIENTE_CONTA(
	nome_completo VARCHAR(100),
	cpf VARCHAR(20),
	idade INTEGER,
	user_name VARCHAR(30),
	senha VARCHAR(100),
	email VARCHAR(100),
	PRIMARY KEY(cpf, user_name)
);

CREATE TABLE FORNECEDOR(
	id_fornecedor INTEGER PRIMARY KEY AUTO_INCREMENT,
	nome_fornecedor VARCHAR(30),
	contato_fornecedor VARCHAR(100),
	servico_fornecido VARCHAR(100)
);

CREATE TABLE FEEDBACK_CLIENTE(
	data_comentario DATETIME,
	id_feedback INTEGER PRIMARY KEY AUTO_INCREMENT,
	comentario VARCHAR(200),
	id_pacote_fk INTEGER
);

CREATE TABLE PACOTE_VIAGEM(
	id_pacote INTEGER PRIMARY KEY AUTO_INCREMENT,
	detalhes_pacote VARCHAR(500),
	destino VARCHAR(50),
	preco DECIMAL(10, 2),
	nome_pacote VARCHAR(50),
	data_viagem DATETIME
);

CREATE TABLE PROMOCAO(
	nome_promocao VARCHAR(50),
	descricao_promocao VARCHAR(500),
    valor_desconto DECIMAL(10, 2),
	id_promocao INTEGER PRIMARY KEY AUTO_INCREMENT
);

CREATE TABLE TEM(
	id_pacote_fk INTEGER,
	id_promocao_fk INTEGER,
	FOREIGN KEY(id_pacote_fk) REFERENCES PACOTE_VIAGEM(id_pacote),
	FOREIGN KEY(id_promocao_fk) REFERENCES PROMOCAO(id_promocao)
);

CREATE TABLE PARCERIA(
	id_pacote_fk INTEGER,
	id_fornecedor_fk INTEGER,
	FOREIGN KEY(id_pacote_fk) REFERENCES PACOTE_VIAGEM(id_pacote),
	FOREIGN KEY(id_fornecedor_fk) REFERENCES FORNECEDOR(id_fornecedor)
);

CREATE TABLE POSTA(
	cpf_fk VARCHAR(20),
	user_name_fk VARCHAR(30),
	id_feedback_fk INTEGER,
	FOREIGN KEY(cpf_fk, user_name_fk) REFERENCES CLIENTE_CONTA(cpf, user_name),
	FOREIGN KEY(id_feedback_fk) REFERENCES FEEDBACK_CLIENTE(id_feedback)
);

CREATE TABLE COMPRA(
	id_pacote_fk INTEGER,
	cpf_fk VARCHAR(20),
	user_name_fk VARCHAR(30),
	FOREIGN KEY(id_pacote_fk) REFERENCES PACOTE_VIAGEM(id_pacote),
	FOREIGN KEY(cpf_fk, user_name_fk) REFERENCES CLIENTE_CONTA(cpf, user_name)
);

ALTER TABLE FEEDBACK_CLIENTE ADD FOREIGN KEY(id_pacote_fk) REFERENCES PACOTE_VIAGEM(id_pacote);

INSERT INTO PACOTE_VIAGEM (detalhes_pacote, destino, preco, nome_pacote, data_viagem) VALUES
('Pacote de aventura nas praias', 'Cancún', 1800.00, 'Aventura nas Praias', '2023-09-10 11:30:00'),
('Pacote histórico em cidade antiga', 'Roma', 1600.75, 'Explorando Roma Antiga', '2023-07-05 10:00:00'),
('Pacote de ecoturismo na floresta', 'Amazonas', 2200.50, 'Expedição na Amazônia', '2023-08-15 13:45:00'),
('Pacote de esqui nas montanhas', 'Alpes Suíços', 2500.25, 'Esqui nos Alpes', '2023-12-01 09:15:00'),
('Pacote cultural em cidade medieval', 'Praga', 1200.00, 'Descobrindo Praga', '2023-10-20 14:30:00'),
('Pacote de praia em ilha paradisíaca', 'Maldivas', 3000.50, 'Paraíso nas Maldivas', '2023-11-08 12:00:00'),
('Pacote de lua de mel exótica', 'Bali', 2800.75, 'Romance em Bali', '2023-06-25 18:45:00'),
('Pacote de negócios com conferência', 'Nova York', 3500.00, 'Conferência em Nova York', '2023-04-20 08:00:00'),
('Pacote de aventura nas cavernas', 'Grutas de Postojna', 1900.25, 'Exploração de Cavernas', '2023-07-15 10:30:00'),
('Pacote de aventura nas montanhas', 'Suiça', 1800.00, 'Aventura nas Montanhas', '2023-09-10 20:30:00');

INSERT INTO FORNECEDOR (nome_fornecedor, contato_fornecedor, servico_fornecido) VALUES
('Empresa A Ltda', '(123) 456-7890', 'Serviços de Buffet'),
('Fornecedores & Cia', '(987) 654-3210', 'Aluguel de Equipamentos'),
('Decoração Charmosa', '(555) 123-4567', 'Decoração de Eventos'),
('Transportadora Veloz', '(777) 888-9999', 'Serviços de Transporte'),
('Click Fotografias', '(333) 222-1111', 'Fotografia e Vídeo'),
('Música ao Vivo Eventos', '(999) 444-3333', 'Serviços de Música ao Vivo'),
('Espaço Versátil', '(777) 555-6666', 'Aluguel de Espaço para Eventos'),
('Flores & Encantos', '(888) 777-6666', 'Serviços de Flores e Arranjos'),
('Iluminação Profissional', '(111) 222-3333', 'Serviços de Iluminação'),
('Aluguel de Tendas & Estruturas', '(555) 888-7777', 'Aluguel de Tendas');

INSERT INTO PARCERIA (id_pacote_fk, id_fornecedor_fk) VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

INSERT INTO PROMOCAO (nome_promocao, descricao_promocao, valor_desconto) VALUES
('Verão20', 'Promoção de Verão 2023', 100.00),
('Inverno21', 'Descontos especiais para o Inverno', 75.50),
('FimDeAno', 'Celebre o final do ano com descontos', 120.25),
('Carnaval2023', 'Promoção especial para o Carnaval', 50.00),
('PrimaveraColorida', 'Descontos na Primavera', 80.75),
('BlackFriday', 'Ofertas imperdíveis na Black Friday', 200.00),
('DiaDosNamorados', 'Especial para casais apaixonados', 90.50),
('VoltaAsAulas', 'Descontos para a volta às aulas', 30.00),
('FeriadoProlongado', 'Aproveite o feriado com descontos', 150.25),
('PromoçãoRelâmpago', 'Ofertas relâmpago por tempo limitado', 70.00);

INSERT INTO TEM (id_pacote_fk, id_promocao_fk) VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);