
-- Banco de Dados: Banco Malvader (compatível com PostgreSQL)

-- Tabela: usuario
CREATE TABLE usuario (
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    tipo_usuario VARCHAR(20) NOT NULL,
    senha_hash VARCHAR(32) NOT NULL,
    otp_ativo VARCHAR(6),
    otp_expiracao TIMESTAMP
);

-- Tabela: funcionario
CREATE TABLE funcionario (
    id_funcionario SERIAL PRIMARY KEY,
    id_usuario INT REFERENCES usuario(id_usuario),
    codigo_funcionario VARCHAR(20) NOT NULL UNIQUE,
    cargo VARCHAR(20) NOT NULL,
    id_supervisor INT REFERENCES funcionario(id_funcionario)
);

-- Tabela: cliente
CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    id_usuario INT REFERENCES usuario(id_usuario),
    score_credito DECIMAL(5,2) DEFAULT 0
);

-- Tabela: endereco
CREATE TABLE endereco (
    id_endereco SERIAL PRIMARY KEY,
    id_usuario INT REFERENCES usuario(id_usuario),
    cep VARCHAR(10) NOT NULL,
    local VARCHAR(100) NOT NULL,
    numero_casa INT NOT NULL,
    bairro VARCHAR(50) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    estado CHAR(2) NOT NULL,
    complemento VARCHAR(50)
);

-- Tabela: agencia
CREATE TABLE agencia (
    id_agencia SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    codigo_agencia VARCHAR(10) NOT NULL UNIQUE,
    endereco_id INT REFERENCES endereco(id_endereco)
);

-- Tabela: conta
CREATE TABLE conta (
    id_conta SERIAL PRIMARY KEY,
    numero_conta VARCHAR(20) NOT NULL UNIQUE,
    id_agencia INT REFERENCES agencia(id_agencia),
    saldo DECIMAL(15,2) NOT NULL DEFAULT 0,
    tipo_conta VARCHAR(20) NOT NULL,
    id_cliente INT REFERENCES cliente(id_cliente),
    data_abertura TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'ATIVA'
);

-- Tabela: conta_poupanca
CREATE TABLE conta_poupanca (
    id_conta_poupanca SERIAL PRIMARY KEY,
    id_conta INT UNIQUE REFERENCES conta(id_conta),
    taxa_rendimento DECIMAL(5,2) NOT NULL,
    ultimo_rendimento TIMESTAMP
);

-- Tabela: conta_corrente
CREATE TABLE conta_corrente (
    id_conta_corrente SERIAL PRIMARY KEY,
    id_conta INT UNIQUE REFERENCES conta(id_conta),
    limite DECIMAL(15,2) NOT NULL DEFAULT 0,
    data_vencimento DATE NOT NULL,
    taxa_manutencao DECIMAL(5,2) NOT NULL DEFAULT 0
);

-- Tabela: conta_investimento
CREATE TABLE conta_investimento (
    id_conta_investimento SERIAL PRIMARY KEY,
    id_conta INT UNIQUE REFERENCES conta(id_conta),
    perfil_risco VARCHAR(10) NOT NULL,
    valor_minimo DECIMAL(15,2) NOT NULL,
    taxa_rendimento_base DECIMAL(5,2) NOT NULL
);

-- Tabela: transacao
CREATE TABLE transacao (
    id_transacao SERIAL PRIMARY KEY,
    id_conta_origem INT REFERENCES conta(id_conta),
    id_conta_destino INT REFERENCES conta(id_conta),
    tipo_transacao VARCHAR(20) NOT NULL,
    valor DECIMAL(15,2) NOT NULL,
    data_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    descricao VARCHAR(100)
);

-- Tabela: auditoria
CREATE TABLE auditoria (
    id_auditoria SERIAL PRIMARY KEY,
    id_usuario INT REFERENCES usuario(id_usuario),
    acao VARCHAR(50) NOT NULL,
    data_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    detalhes TEXT
);

-- Tabela: relatorio
CREATE TABLE relatorio (
    id_relatorio SERIAL PRIMARY KEY,
    id_funcionario INT REFERENCES funcionario(id_funcionario),
    tipo_relatorio VARCHAR(50) NOT NULL,
    data_geracao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    conteudo TEXT NOT NULL
);
