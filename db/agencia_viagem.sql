CREATE DATABASE agencia_viagem2;

USE agencia_viagem2;

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