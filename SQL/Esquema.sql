CREATE TABLE Deficiencia (
    cid CHAR(3) NOT NULL,
    nome VARCHAR2(30) NOT NULL,
    tipo VARCHAR2(15) NOT NULL,

    CONSTRAINT pk_deficiencia PRIMARY KEY cid,
    CONSTRAINT ck_tipo CHECK (tipo IN ('VISUAL', 'AUDITIVA', 'FÍSICA', 'INTELECTUAL', 'PSICOSOCIAL'))
);

CREATE TABLE Escola (
    cnpj CHAR(14) NOT NULL,
    nome VARCHAR2(30) NOT NULL,
    email VARCHAR2(30) NOT NULL,
    rua VARCHAR2(30) NOT NULL,
    numero NUMBER NOT NULL,
    bairro VARCHAR2(30) NOT NULL,
    cidade VARCHAR2(30) NOT NULL,
    estado CHAR(2) NOT NULL,
    natureza CHAR(7) NOT NULL,
    telefone_fixo CHAR(10),
    telefone_celular CHAR(11),

    CONSTRAINT pk_escola PRIMARY KEY cnpj,
    CONSTRAINT ck_natureza CHECK (natureza IN ('PUBLICA', 'PRIVADA'))
);

CREATE TABLE Curso (
    nome VARCHAR2(30) NOT NULL,
    duracao NUMBER NOT NULL, -- Em semanas
    descricao VARCHAR2(120),
    deficiencia CHAR(3) NOT NULL,

    CONSTRAINT pk_curso PRIMARY KEY nome,
    CONSTRAINT fk_curso_deficiencia FOREIGN KEY deficiencia REFERENCES Deficiencia(cid)
    CONSTRAINT ck_duracao CHECK (duracao > 0)
);

CREATE TABLE Vinculo (
    cpf CHAR(11) NOT NULL,
    vinculo VARCHAR2(10) NOT NULL,

    CONSTRAINT pk_vinculo PRIMARY KEY cpf,
    CONSTRAINT ck_vinculo CHECK (vinculo IN ('PROFESSOR', 'ASSISTENTE'))
);

CREATE TABLE Professor (
    cpf CHAR(11) NOT NULL,
    nome VARCHAR2(30) NOT NULL,
    rua VARCHAR2(30) NOT NULL,
    numero NUMBER NOT NULL,
    bairro VARCHAR2(30) NOT NULL,
    cidade VARCHAR2(30) NOT NULL,
    estado CHAR(2) NOT NULL,
    telefone_fixo CHAR(10),
    telefone_celular CHAR(11),
    formacao VARCHAR2(30),

    CONSTRAINT pk_professor PRIMARY KEY cpf,
);

CREATE TABLE Assistente (
    cpf CHAR(11) NOT NULL,
    nome VARCHAR2(30) NOT NULL,
    rua VARCHAR2(30) NOT NULL,
    numero NUMBER NOT NULL,
    bairro VARCHAR2(30) NOT NULL,
    cidade VARCHAR2(30) NOT NULL,
    estado CHAR(2) NOT NULL,
    telefone_fixo CHAR(10),
    telefone_celular CHAR(11),

    CONSTRAINT pk_assistente PRIMARY KEY cpf,
);

CREATE TABLE Oferecimento (
    num_contrato CHAR(10) NOT NULL,
    curso VARCHAR2(30) NOT NULL,
    escola CHAR(14) NOT NULL,
    professor CHAR(11) NOT NULL,
    doacao NUMBER DEFAULT 0,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,

    CONSTRAINT pk_oferecimento PRIMARY KEY num_contrato,
    CONSTRAINT fk_oferecimento_curso FOREIGN KEY curso REFERENCES Curso(nome),
    CONSTRAINT fk_oferecimento_escola FOREIGN KEY escola REFERENCES Escola(cnpj),
    CONSTRAINT fk_oferecimento_professor FOREIGN KEY professor REFERENCES Professor(cpf)
);

CREATE TABLE Aluno (
    cpf CHAR(11) NOT NULL,
    deficiencia CHAR(3) NOT NULL,
    grau CHAR(1) NOT NULL,
    nome VARCHAR2(30) NOT NULL,
    atestado VARCHAR2(30) NOT NULL,
    telefone_fixo CHAR(10),
    telefone_celular CHAR(11),

    CONSTRAINT pk_aluno PRIMARY KEY cpf,
    CONSTRAINT fk_aluno_deficiencia FOREIGN KEY deficiencia REFERENCES Deficiencia(cid),
    CONSTRAINT ck_grau CHECK (grau IN ('A', 'B', 'C', 'D', 'E')) 
);

CREATE TABLE Aula (
    id NUMBER NOT NULL,
    oferecimento CHAR(10) NOT NULL,
    data_hora_inicio DATE NOT NULL,
    data_hora_fim DATE NOT NULL,
    sitio VARCHAR2(30) NOT NULL,
    numeracao CHAR(2) NOT NULL,

    CONSTRAINT pk_aula PRIMARY KEY id,
    CONSTRAINT un_oferecimento_data UNIQUE (oferecimento, data_hora_inicio),
    CONSTRAINT fk_aula_oferecimento FOREIGN KEY oferecimento REFERENCES Oferecimento(num_contrato)
);


CREATE TABLE Presenca (
    aluno CHAR(11) NOT NULL,
    aula NUMBER NOT NULL,
    assistente CHAR(11) NOT NULL,

    CONSTRAINT pk_presenca PRIMARY KEY (aluno, aula),
    CONSTRAINT fk_presenca_aluno FOREIGN KEY aluno REFERENCES Aluno(cpf),
    CONSTRAINT fk_presenca_aula FOREIGN KEY aula REFERENCES Aula(id),
    CONSTRAINT fk_presenca_assistente FOREIGN KEY assistente REFERENCES Assistente(cpf)
);

CREATE TABLE Recurso (
    num_patrimonio CHAR(10) NOT NULL,
    tipo VARCHAR2(30) NOT NULL,
    nome VARCHAR2(30) NOT NULL,

    CONSTRAINT pk_recurso PRIMARY KEY num_patrimonio
);

CREATE TABLE Aula_Recurso (
    aula NUMBER NOT NULL,
    recurso CHAR(10) NOT NULL,

    CONSTRAINT pk_aula_recurso PRIMARY KEY (aula, recurso),
    CONSTRAINT fk_aula_recurso_aula FOREIGN KEY aula REFERENCES Aula(id),
    CONSTRAINT fk_aula_recurso_recurso FOREIGN KEY recurso REFERENCES Recurso(num_patrimonio)
);

