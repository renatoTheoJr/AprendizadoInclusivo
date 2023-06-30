-- Consulta recursos que um oferecimento usa - Rafael
SELECT R.num_patrimonio, R.nome, R.tipo
    FROM Recurso R
    INNER JOIN Aula_Recurso AR ON AR.recurso = R.num_patrimonio
    INNER JOIN Aula A ON A.id = AR.aula
    INNER JOIN Oferecimento O ON O.num_contrato = A.oferecimento
    WHERE O.num_contrato = 'CON0000001';

-- Consulta alunos que tem presença em todas as aulas de um oferecimento - Rafael
SELECT A.nome
    FROM Aluno A
    INNER JOIN Presenca P ON P.aluno = A.cpf
    INNER JOIN Aula AU ON AU.id = P.aula
    INNER JOIN Oferecimento O ON O.num_contrato = AU.oferecimento
    WHERE O.num_contrato = 'CON0000001'
    GROUP BY A.nome
    HAVING COUNT(*) = (
        SELECT COUNT(*)
        FROM Aula AU
        WHERE AU.oferecimento = 'CON0000001'
    );


 -- Lista todos os alunos que não faltaram nenhuma aula do contrato CON0000001

SELECT A.nome
    FROM Aluno A WHERE
    NOT EXISTS (
        (SELECT Au.id
            FROM Aula Au
            WHERE Au.oferecimento = 'CON0000001')
        MINUS
        (SELECT P.aula
            FROM Presenca P
            WHERE P.aluno = A.cpf
        )
    );

-- Lista todos os alunos que frequentaram pelo menos uma aula de todos ofereciementos do professor 48425678056
SELECT A.nome
    FROM Aluno A
    WHERE NOT EXISTS (
        (SELECT O.num_contrato
            FROM Oferecimento O
            WHERE O.professor = '48425678056')
        MINUS
        (SELECT Au.oferecimento
            FROM Aula Au
            WHERE Au.id IN (SELECT P.aula 
                                FROM Presenca P
                                WHERE P.aluno = A.cpf))
    );

-- Listar deficiências que são abrangidas por pelo menos 3 cursos
select d.cid from deficiencia d inner join curso c on c.deficiencia = d.cid
group by d.cid
having count(*) >=3


-- Listar todos os oferencimentos que não tiveram nenhuma aula
select o.num_contrato from oferecimento o left join aula a on a.oferecimento = o.num_contrato
where a.id is null


-- Listar todas as escolas que o tempo de duração do contrato é maior que 1 ano
select e.nome, o.num_contrato from escola e inner join oferecimento o on o.escola = e.cnpj
where o.data_fim - o.data_inicio > 365

-- Listar todas as escolas que o tempo de contrato já encerrou
select e.nome, o.num_contrato from escola e inner join oferecimento o on o.escola = e.cnpj
where o.data_fim < sysdate 


-- Listar quantos contratos ativos cada escola tem
select e.nome, count(*) as contrato_ativo from escola e inner join oferecimento o on o.escola = e.cnpj
where o.data_fim > sysdate
group by e.nome

--Listar nome de escolas em que um professor da aula atualmente
select e.nome as escola, p.nome as professor from escola e inner join oferecimento o on o.escola = e.cnpj and o.data_fim > sysdate 
inner join professor p on p.cpf = o.professor


-- Listar deficiências que não são abrangidas por nenhum curso
select d.cid from deficiencia d left join curso c on c.deficiencia = d.cid
where c.cid is null

-- Listar deficiências e se tiver seus respectivos cursos
select d.cid, c.nome from deficiencia d left join curso c on c.deficiencia = d.cid
