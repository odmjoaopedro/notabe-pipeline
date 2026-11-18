USE notabe_dbsql;

-- 1 tabela de estabelecimentos emissores (dimensao)
CREATE TABLE IF NOT EXISTS estabelecimentos (
    cnpj VARCHAR(14) PRIMARY KEY,
    razao_social VARCHAR(150),
    uf CHAR(2),
    criado TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2 tabela de lotes de escaneamento (controle de entrada)
CREATE TABLE IF NOT EXISTS lotes_escaneamento (
    id_lote INT AUTO_INCREMENT PRIMARY KEY,
    arquivo_origem VARCHAR(255) NOT NULL,
    total_chaves INT DEFAULT 0,
    data_importacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3 tabela principal de notas fiscais (controle de estado)
CREATE TABLE IF NOT EXISTS notas_fiscais (
    id_nota INT AUTO_INCREMENT PRIMARY KEY,
    chave_acesso CHAR(44) NOT NULL UNIQUE,
    id_lote INT,
    cnpj_emitente VARCHAR(14),
    data_emissao DATE,
    valor_nota DECIMAL(10, 2),
    valor_creditado DECIMAL(10, 2),
    status_processamento ENUM('PENDENTE', 'ENVIADO', 'CONSOLIDADO', 'ERRO') NOT NULL DEFAULT 'PENDENTE',
    mensagem_erro VARCHAR(255),
    criado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_nota_lote
        FOREIGN KEY (id_lote) REFERENCES lotes_escaneamento(id_lote)
        ON DELETE SET NULL,
    CONSTRAINT fk_nota_estabelecimento
        FOREIGN KEY (cnpj_emitente) REFERENCES estabelecimentos(cnpj)
    ON DELETE SET NULL
);

CREATE INDEX idx_notas_status ON notas_fiscais(status_processamento);
CREATE INDEX idx_notas_data_emissao ON notas_fiscais(data_emissao);