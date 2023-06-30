 -- Lista todos os alunos que não faltaram nenhuma aula do contrato CON0000001
SELECT A.nome FROM aluno A WHERE
NOT EXISTS((
    SELECT id FROM aula au WHERE
    au.oferecimento = 'CON0000001')
    minus
    (
        SELECT P.aula FROM presenca P WHERE
        P.aluno = A.cpf
    )
)

-- Lista todos os alunos que frequentaram pelo menos uma aula de todos ofereciementos do professor 26576719000
SELECT A.nome FROM aluno A WHERE
NOT EXISTS((
    SELECT O.num_contrato FROM oferecimento O WHERE
    O.professor = '48425678056')
    minus
    (
        SELECT au.oferecimento FROM aula au WHERE
        au.id IN (SELECT P.aula FROM presenca P WHERE
        P.aluno = A.cpf)
    )
) 

-- Listar deficiências que são abrangidas por pelo menos 3 cursos
SELECT d.cid FROM deficiencia d INNER JOIN curso c ON c.deficiencia = d.cid
GROUP BY d.cid
HAVING COUNT(*) >=3


-- Listar todos os oferencimentos que não tiveram nenhuma aula
SELECT O.num_contrato FROM oferecimento O left join aula A ON A.oferecimento = O.num_contrato
WHERE A.id IS NULL


-- Listar todas AS escolas que O tempo de duração do contrato é maior que 1 ano
SELECT E.nome, O.num_contrato FROM escola E INNER JOIN oferecimento O ON O.escola = E.cnpj
WHERE O.data_fim - O.data_inicio > 365

-- Listar todas AS escolas que O tempo de contrato já encerrou
SELECT E.nome, O.num_contrato FROM escola E INNER JOIN oferecimento O ON O.escola = E.cnpj
WHERE O.data_fim < SYSDATE 


-- Listar quantos contratos ativos cada escola tem
SELECT E.nome, COUNT(*) AS contrato_ativo FROM escola E INNER JOIN oferecimento O ON O.escola = E.cnpj
WHERE O.data_fim > SYSDATE
GROUP BY E.nome

--Listar nome de escolas em que um professor da aula atualmente
SELECT E.nome AS escola, P.nome AS professor FROM escola E INNER JOIN oferecimento O ON O.escola = E.cnpj AND O.data_fim > SYSDATE 
INNER JOIN professor P ON P.cpf = O.professor


-- Listar deficiências que não são abrangidas por nenhum curso
SELECT d.cid FROM deficiencia d left join curso c ON c.deficiencia = d.cid
WHERE c.cid IS NULL

-- Listar deficiências E se tiver seus respectivos cursos
SELECT d.cid, c.nome FROM deficiencia d left join curso c ON c.deficiencia = d.cid

-- Listar todas AS aulas oferecidas em 2020 que usaram mais de dois recursos:
SELECT A.id, A.oferecimento, A.data_hora_inicio, A.data_hora_fim, A.sitio, A.numeracao
FROM Aula A
INNER JOIN Oferecimento O ON A.oferecimento = O.num_contrato
INNER JOIN Aula_Recurso AR ON A.id = AR.aula
INNER JOIN Recurso R ON AR.recurso = R.num_patrimonio
WHERE EXTRACT(YEAR FROM A.data_hora_inicio) = 2020
GROUP BY A.id, A.oferecimento, A.data_hora_inicio, A.data_hora_fim, A.sitio, A.numeracao
HAVING COUNT(R.num_patrimonio) > 2;

-- Listar os alunos matriculados em um determinado curso:
SELECT A.cpf, A.deficiencia, A.grau, A.nome, A.atestado, A.telefone_fixo, A.telefone_celular
FROM Aluno A
INNER JOIN Curso C ON A.deficiencia = C.deficiencia
WHERE C.nome = 'Introdução à Informática';

-- Listar os recursos que um oferecimento usa:
SELECT R.num_patrimonio, R.tipo, R.nome
FROM Recurso R
INNER JOIN Aula_Recurso AR ON R.num_patrimonio = AR.recurso
INNER JOIN Aula A ON AR.aula = A.id
INNER JOIN Oferecimento O ON A.oferecimento = O.num_contrato
WHERE O.num_contrato = 'CON0000001';