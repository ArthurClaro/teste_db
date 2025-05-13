

-- Tabela: usuario
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    tipo_usuario ENUM('FUNCIONARIO', 'CLIENTE') NOT NULL,
    senha_hash VARCHAR(32) NOT NULL,
    otp_ativo VARCHAR(6),
    otp_expiracao DATETIME
);

-- Tabela: funcionario
CREATE TABLE funcionario (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    codigo_funcionario VARCHAR(20) UNIQUE NOT NULL,
    cargo ENUM('ESTAGIARIO', 'ATENDENTE', 'GERENTE') NOT NULL,
    id_supervisor INT,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_supervisor) REFERENCES funcionario(id_funcionario)
);

-- Tabela: cliente
CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    score_credito DECIMAL(5,2) DEFAULT 0,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- Tabela: endereco
CREATE TABLE endereco (
    id_endereco INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    cep VARCHAR(10) NOT NULL,
    local VARCHAR(100) NOT NULL,
    numero_casa INT NOT NULL,
    bairro VARCHAR(50) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    estado CHAR(2) NOT NULL,
    complemento VARCHAR(50),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- Tabela: agencia
CREATE TABLE agencia (
    id_agencia INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    codigo_agencia VARCHAR(10) UNIQUE NOT NULL,
    endereco_id INT,
    FOREIGN KEY (endereco_id) REFERENCES endereco(id_endereco)
);

-- Tabela: conta
CREATE TABLE conta (
    id_conta INT AUTO_INCREMENT PRIMARY KEY,
    numero_conta VARCHAR(20) UNIQUE NOT NULL,
    id_agencia INT,
    saldo DECIMAL(15,2) NOT NULL DEFAULT 0,
    tipo_conta ENUM('POUPANCA', 'CORRENTE', 'INVESTIMENTO') NOT NULL,
    id_cliente INT,
    data_abertura DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status ENUM('ATIVA', 'ENCERRADA', 'BLOQUEADA') NOT NULL DEFAULT 'ATIVA',
    FOREIGN KEY (id_agencia) REFERENCES agencia(id_agencia),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- Tabela: conta_poupanca
CREATE TABLE conta_poupanca (
    id_conta_poupanca INT AUTO_INCREMENT PRIMARY KEY,
    id_conta INT UNIQUE,
    taxa_rendimento DECIMAL(5,2) NOT NULL,
    ultimo_rendimento DATETIME,
    FOREIGN KEY (id_conta) REFERENCES conta(id_conta)
);

-- Tabela: conta_corrente
CREATE TABLE conta_corrente (
    id_conta_corrente INT AUTO_INCREMENT PRIMARY KEY,
    id_conta INT UNIQUE,
    limite DECIMAL(15,2) NOT NULL DEFAULT 0,
    data_vencimento DATE NOT NULL,
    taxa_manutencao DECIMAL(5,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (id_conta) REFERENCES conta(id_conta)
);

-- Tabela: conta_investimento
CREATE TABLE conta_investimento (
    id_conta_investimento INT AUTO_INCREMENT PRIMARY KEY,
    id_conta INT UNIQUE,
    perfil_risco ENUM('BAIXO', 'MEDIO', 'ALTO') NOT NULL,
    valor_minimo DECIMAL(15,2) NOT NULL,
    taxa_rendimento_base DECIMAL(5,2) NOT NULL,
    FOREIGN KEY (id_conta) REFERENCES conta(id_conta)
);

-- Tabela: transacao
CREATE TABLE transacao (
    id_transacao INT AUTO_INCREMENT PRIMARY KEY,
    id_conta_origem INT,
    id_conta_destino INT,
    tipo_transacao ENUM('DEPOSITO', 'SAQUE', 'TRANSFERENCIA', 'TAXA', 'RENDIMENTO') NOT NULL,
    valor DECIMAL(15,2) NOT NULL,
    data_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    descricao VARCHAR(100),
    FOREIGN KEY (id_conta_origem) REFERENCES conta(id_conta),
    FOREIGN KEY (id_conta_destino) REFERENCES conta(id_conta)
);

-- Tabela: auditoria
CREATE TABLE auditoria (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    acao VARCHAR(50) NOT NULL,
    data_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    detalhes TEXT,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- Tabela: relatorio
CREATE TABLE relatorio (
    id_relatorio INT AUTO_INCREMENT PRIMARY KEY,
    id_funcionario INT,
    tipo_relatorio VARCHAR(50) NOT NULL,
    data_geracao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    conteudo TEXT NOT NULL,
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario)
);
