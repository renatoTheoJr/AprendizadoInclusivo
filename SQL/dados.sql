INSERT INTO Deficiencia (cid, nome, tipo)
    VALUES ('001', 'Deficiêcia Visual', 'VISUAL');
INSERT INTO Deficiencia (cid, nome, tipo)
    VALUES ('002', 'Deficiêcia Física', 'FÍSICA');

INSERT INTO Escola (cnpj, nome, email, rua, numero, bairro, cidade, estado, natureza, telefone_fixo, telefone_celular)
    VALUES ('12345678901234', 'Escola Estadual ABC', 'escolaabc@example.com', 'Rua das Escolas', 123, 'Centro', 'Cidade A', 'SP', 'PUBLICA', '1122334455', '9988776655');

INSERT INTO Escola (cnpj, nome, email, rua, numero, bairro, cidade, estado, natureza, telefone_fixo, telefone_celular)
    VALUES ('98765432109876', 'Escola Particular XYZ', 'escolaxyz@example.com', 'Avenida das Escolas', 456, 'Bairro X', 'Cidade B', 'RJ', 'PRIVADA', '5544332211', '5566778899');

INSERT INTO Curso (nome, duracao, descricao, deficiencia)
    VALUES ('Introdução à Informática', 10, 'Aprenda conceitos básicos de informática e uso de computadores', '001');

INSERT INTO Curso (nome, duracao, descricao, deficiencia)
    VALUES ('Introdução à celulares', 10, 'Aprenda conceitos básicos de como usar um celular', '001');

INSERT INTO Curso (nome, duracao, descricao, deficiencia)
    VALUES ('Redes sociais', 10, 'Aprenda como ter sua rede social', '001');

INSERT INTO Curso (nome, duracao, descricao, deficiencia)
    VALUES ('Programação em Python', 12, 'Aprenda a programar utilizando a linguagem Python', '002');

INSERT INTO Professor (cpf, nome, rua, numero, bairro, cidade, estado, telefone_fixo, telefone_celular, formacao)
    VALUES ('48425678056', 'João Silva', 'Rua dos Professores', 123, 'Centro', 'Cidade A', 'SP', '1122334455', '9988776655', 'BCC');

INSERT INTO Professor (cpf, nome, rua, numero, bairro, cidade, estado, telefone_fixo, telefone_celular, formacao)
    VALUES ('26576719000', 'Maria Souza', 'Avenida das Escolas', 456, 'Bairro X', 'Cidade B', 'RJ', '5544332211', '5566778899', 'BSI');

INSERT INTO Assistente (cpf, nome, rua, numero, bairro, cidade, estado, telefone_fixo, telefone_celular)
    VALUES ('55738026071', 'Pedro Oliveira', 'Rua dos Assistentes', 321, 'Centro', 'Cidade A', 'SP', '1122334455', '9988776655');

INSERT INTO Assistente (cpf, nome, rua, numero, bairro, cidade, estado, telefone_fixo, telefone_celular)
    VALUES ('25547587001', 'Ana Santos', 'Avenida dos Assistentes', 654, 'Bairro Y', 'Cidade B', 'RJ', '5544332211', '5566778899');

INSERT INTO Vinculo (cpf, vinculo)
    VALUES ('48425678056', 'PROFESSOR');
INSERT INTO Vinculo (cpf, vinculo)
    VALUES ('26576719000', 'PROFESSOR');
INSERT INTO Vinculo (cpf, vinculo)
    VALUES ('55738026071', 'ASSISTENTE');
INSERT INTO Vinculo (cpf, vinculo)
    VALUES ('25547587001', 'ASSISTENTE');


INSERT INTO Oferecimento (num_contrato, curso, escola, professor, doacao, data_inicio, data_fim)
    VALUES ('CON0000001', 'Introdução à Informática', '12345678901234', '48425678056', 0, TO_DATE('01/06/2023','dd/mm/yyyy'),TO_DATE('31/07/2023','dd/mm/yyyy'));

INSERT INTO Oferecimento (num_contrato, curso, escola, professor, doacao, data_inicio, data_fim)
    VALUES ('CON0000002', 'Programação em Python', '98765432109876', '26576719000', 500.00, TO_DATE('15/07/2023','dd/mm/yyyy'),TO_DATE('15/09/2023','dd/mm/yyyy'));

INSERT INTO Oferecimento (num_contrato, curso, escola, professor, doacao, data_inicio, data_fim)
    VALUES ('CON0000003', 'Redes sociais', '98765432109876', '26576719000', 500.00, TO_DATE('15/07/2020','dd/mm/yyyy'),TO_DATE('15/09/2020','dd/mm/yyyy'));


INSERT INTO Aluno (cpf, deficiencia, grau, nome, atestado, telefone_fixo, telefone_celular)
    VALUES ('80462935043', '001', 'B', 'Joana Santos', 'Atestado MÃ©dico', '1122334455', '9988776655');

INSERT INTO Aluno (cpf, deficiencia, grau, nome, atestado, telefone_fixo, telefone_celular)
    VALUES ('37034141037', '002', 'C', 'Ricardo Silva', 'Atestado Escolar', '5544332211', '5566778899');
INSERT INTO Aluno (cpf, deficiencia, grau, nome, atestado, telefone_fixo, telefone_celular)
    VALUES ('77284063025', '001', 'A', 'Fernanda Oliveira', 'Atestado MÃ©dico', NULL, '9911223344');

INSERT INTO Aluno (cpf, deficiencia, grau, nome, atestado, telefone_fixo, telefone_celular)
    VALUES ('63567319078', '002', 'D', 'Lucas Pereira', 'Atestado Escolar', NULL, '9988776655');

INSERT INTO Aluno (cpf, deficiencia, grau, nome, atestado, telefone_fixo, telefone_celular)
    VALUES ('64514589020', '001', 'E', 'Camila Costa', 'Atestado MÃ©dico', '1122334455', NULL);


INSERT INTO Aula (id, oferecimento, data_hora_inicio, data_hora_fim, sitio, numeracao)
    VALUES (1, 'CON0000001', TO_DATE('10/06/2023 09:00:00','DD/MM/YYYY HH24:MI:SS'), TO_DATE('10/06/2023 12:00:00','dd/mm/yyyy HH24:MI:SS'), 'Sala 101', '01');

INSERT INTO Aula (id, oferecimento, data_hora_inicio, data_hora_fim, sitio, numeracao)
    VALUES (2, 'CON0000001', TO_DATE('17/06/2023 14:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('17/06/2023 17:00:00','dd/mm/yyyy HH24:MI:SS'), 'Sala 102', '02');
INSERT INTO Aula (id, oferecimento, data_hora_inicio, data_hora_fim, sitio, numeracao)
    VALUES (3, 'CON0000001', TO_DATE('18/06/2023 14:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('18/06/2023 17:00:00','dd/mm/yyyy HH24:MI:SS'), 'Sala 102', '02');

INSERT INTO Aula (id, oferecimento, data_hora_inicio, data_hora_fim, sitio, numeracao)
    VALUES (4, 'CON0000001', TO_DATE('19/06/2023 14:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('19/06/2023 17:00:00','dd/mm/yyyy HH24:MI:SS'), 'Sala 102', '02');

INSERT INTO Aula (id, oferecimento, data_hora_inicio, data_hora_fim, sitio, numeracao)
    VALUES (5, 'CON0000002', TO_DATE('15/06/2023 14:00:00','DD/MM/YYYY HH24:MI:SS'),TO_DATE('15/06/2023 17:00:00','dd/mm/yyyy HH24:MI:SS'), 'Sala 102', '02');



INSERT INTO Presenca (aluno, aula, assistente)
    VALUES ('77284063025', 1, '55738026071');
INSERT INTO Presenca (aluno, aula, assistente)
    VALUES ('77284063025', 2, '55738026071');
INSERT INTO Presenca (aluno, aula, assistente)
    VALUES ('77284063025', 3, '25547587001');
INSERT INTO Presenca (aluno, aula, assistente)
    VALUES ('77284063025', 4, '25547587001');
INSERT INTO Presenca (aluno, aula, assistente)
    VALUES ('77284063025', 5, '55738026071');

INSERT INTO Presenca (aluno, aula, assistente)
    VALUES ('64514589020', 1, '55738026071');
INSERT INTO Presenca (aluno, aula, assistente)
    VALUES ('64514589020', 3, '25547587001');
INSERT INTO Presenca (aluno, aula, assistente)
    VALUES ('64514589020', 4, '25547587001');



INSERT INTO Presenca (aluno, aula, assistente)
    VALUES ('64514589020', 2, '55738026071');


INSERT INTO Recurso (num_patrimonio, tipo, nome)
    VALUES ('1234567890', 'Computador', 'Computador de Mesa');

INSERT INTO Recurso (num_patrimonio, tipo, nome)
    VALUES ('9876543210', 'Projetor', 'Projetor Multimídia');

INSERT INTO Aula_Recurso (aula, recurso)
    VALUES (1, '1234567890');

INSERT INTO Aula_Recurso (aula, recurso)
    VALUES (2, '9876543210');
