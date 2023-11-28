CREATE DATABASE agencia_viagem;

USE agencia_viagem;

CREATE TABLE `CLIENTE_CONTA` (
  `nome_completo` varchar(100) DEFAULT NULL,
  `cpf` varchar(20) NOT NULL,
  `idade` int DEFAULT NULL,
  `user_name` varchar(30) NOT NULL,
  `senha` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`cpf`,`user_name`)
);

CREATE TABLE `COMPRA` (
  `id_pacote_fk` varchar(50) DEFAULT NULL,
  `cpf_fk` varchar(20) DEFAULT NULL,
  `user_name_fk` varchar(30) DEFAULT NULL,
  KEY `id_pacote_fk` (`id_pacote_fk`),
  KEY `cpf_fk` (`cpf_fk`,`user_name_fk`),
  CONSTRAINT `COMPRA_ibfk_1` FOREIGN KEY (`id_pacote_fk`) REFERENCES `PACOTE_VIAGEM` (`id_pacote`),
  CONSTRAINT `COMPRA_ibfk_2` FOREIGN KEY (`cpf_fk`, `user_name_fk`) REFERENCES `CLIENTE_CONTA` (`cpf`, `user_name`)
);

CREATE TABLE `FEEDBACK_CLIENTE` (
  `data_comentario` datetime DEFAULT NULL,
  `id_feedback` varchar(50) NOT NULL,
  `comentario` varchar(200) DEFAULT NULL,
  `id_pacote` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_feedback`),
  KEY `id_pacote` (`id_pacote`),
  CONSTRAINT `FEEDBACK_CLIENTE_ibfk_1` FOREIGN KEY (`id_pacote`) REFERENCES `PACOTE_VIAGEM` (`id_pacote`)
);

CREATE TABLE `FORNECEDOR` (
  `id_fornecedor` varchar(50) NOT NULL,
  `nome_fornecedor` varchar(30) DEFAULT NULL,
  `contato_fornecedor` varchar(100) DEFAULT NULL,
  `sevico_fornecido` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id_fornecedor`)
);

CREATE TABLE `PACOTE_VIAGEM` (
  `id_pacote` varchar(50) NOT NULL,
  `detalhes_pacote` varchar(500) DEFAULT NULL,
  `destino` varchar(50) DEFAULT NULL,
  `preco` decimal(10,2) DEFAULT NULL,
  `nome_pacote` varchar(50) DEFAULT NULL,
  `data_viagem` datetime DEFAULT NULL,
  PRIMARY KEY (`id_pacote`)
);

CREATE TABLE `PARCERIA` (
  `id_pacote_fk` varchar(50) DEFAULT NULL,
  `id_fornecedor_fk` varchar(50) DEFAULT NULL,
  KEY `id_pacote_fk` (`id_pacote_fk`),
  KEY `id_fornecedor_fk` (`id_fornecedor_fk`),
  CONSTRAINT `PARCERIA_ibfk_1` FOREIGN KEY (`id_pacote_fk`) REFERENCES `PACOTE_VIAGEM` (`id_pacote`),
  CONSTRAINT `PARCERIA_ibfk_2` FOREIGN KEY (`id_fornecedor_fk`) REFERENCES `FORNECEDOR` (`id_fornecedor`)
);

CREATE TABLE `POSTA` (
  `cpf_fk` varchar(20) DEFAULT NULL,
  `user_name_fk` varchar(30) DEFAULT NULL,
  `id_feedback_fk` varchar(50) DEFAULT NULL,
  KEY `cpf_fk` (`cpf_fk`,`user_name_fk`),
  KEY `id_feedback_fk` (`id_feedback_fk`),
  CONSTRAINT `POSTA_ibfk_1` FOREIGN KEY (`cpf_fk`, `user_name_fk`) REFERENCES `CLIENTE_CONTA` (`cpf`, `user_name`),
  CONSTRAINT `POSTA_ibfk_2` FOREIGN KEY (`id_feedback_fk`) REFERENCES `FEEDBACK_CLIENTE` (`id_feedback`)
);

CREATE TABLE `PROMOCAO` (
  `nome_promocao` varchar(50) DEFAULT NULL,
  `descricao_promocao` varchar(500) DEFAULT NULL,
  `id_promocao` varchar(50) NOT NULL,
  PRIMARY KEY (`id_promocao`)
);

CREATE TABLE `TEM` (
  `id_pacote_fk` varchar(50) DEFAULT NULL,
  `id_promocao_fk` varchar(50) DEFAULT NULL,
  KEY `id_pacote_fk` (`id_pacote_fk`),
  KEY `id_promocao_fk` (`id_promocao_fk`),
  CONSTRAINT `TEM_ibfk_1` FOREIGN KEY (`id_pacote_fk`) REFERENCES `PACOTE_VIAGEM` (`id_pacote`),
  CONSTRAINT `TEM_ibfk_2` FOREIGN KEY (`id_promocao_fk`) REFERENCES `PROMOCAO` (`id_promocao`)
);
