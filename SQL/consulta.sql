-- Consulta recursos que um oferecimento usa 
-- Para essa consulta foi necessário fazer um join entre as tabelas Recurso, Aula_Recurso, Aula e Oferecimento,
-- Foi utilizado o oferecimento como filtro para a consulta e foi selecionado o nome, tipo e número de patrimônio do recurso
SELECT R.num_patrimonio, R.nome, R.tipo
    FROM Recurso R
    INNER JOIN Aula_Recurso AR ON AR.recurso = R.num_patrimonio
    INNER JOIN Aula A ON A.id = AR.aula
    INNER JOIN Oferecimento O ON O.num_contrato = A.oferecimento
    WHERE O.num_contrato = 'CON0000001';

-- Consulta alunos que tem presença em todas as aulas de um oferecimento 
-- Para essa consulta foi necessário fazer um join entre as tabelas Aluno, Presença, Aula e Oferecimento,
-- Foi utilizado uma consulta alinhada para selecionar o número de aulas do oferecimento e foi utilizado o oferecimento como filtro para a consulta
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
-- Foi utilizado uma divisão relacional para conseguir listar os alunos que não faltaram nenhuma aula
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
-- Foi utlizado divisão relacional para conseguir listar os alunos que frequentaram pelo menos uma aula de todos os oferecimentos do professor
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
-- Foi utilizado um groupby para agrupar as deficiências e um having para filtrar as deficiências que são abrangidas por pelo menos 3 cursos
SELECT d.cid FROM deficiencia d INNER JOIN curso c ON c.deficiencia = d.cid
GROUP BY d.cid
HAVING COUNT(*) >=3


-- Listar todos os oferencimentos que não tiveram nenhuma aula
-- Foi utilizado um left join para listar os oferecimentos que não tiveram nenhuma aula, para isso foi utilizado o atributo id da tabela aula 
-- e o comparando com nulo
SELECT O.num_contrato
    FROM oferecimento O
    left join aula A ON A.oferecimento = O.num_contrato
    WHERE A.id IS NULL;


-- Listar todas AS escolas que O tempo de duração do contrato é maior que 1 ano
-- Foi utilizado uma operação de subtração entre as datas de fim e início do contrato para conseguir o tempo de duração do contrato
SELECT E.nome, O.num_contrato
    FROM escola E
    INNER JOIN oferecimento O ON O.escola = E.cnpj
    WHERE O.data_fim - O.data_inicio > 365;

-- Listar todas AS escolas que O tempo de contrato já encerrou
-- Foi utilizado a data atual do sistema (sysdate) para comparar com a data de fim do contrato
SELECT E.nome, O.num_contrato
    FROM escola E
    INNER JOIN oferecimento O ON O.escola = E.cnpj
    WHERE O.data_fim < SYSDATE;


-- Listar quantos contratos ativos cada escola tem
-- É considerado um contrato ativo aquele que a data de fim é maior que a data atual do sistema
SELECT E.nome, COUNT(*) AS contrato_ativo
    FROM escola E
    INNER JOIN oferecimento O ON O.escola = E.cnpj
    WHERE O.data_fim > SYSDATE
    GROUP BY E.nome;

--Listar nome de escolas em que um professor da aula atualmente
--Foi utilizado um inner join entre as tabelas escola, oferecimento e professor para conseguir listar as escolas em que um professor da aula atualmente
SELECT E.nome AS escola, P.nome AS professor
    FROM escola E
    INNER JOIN oferecimento O ON O.escola = E.cnpj AND O.data_fim > SYSDATE 
    INNER JOIN professor P ON P.cpf = O.professor;


-- Listar deficiências que não são abrangidas por nenhum curso
-- Foi utilizado um left join entre as tabelas deficiência e curso para conseguir listar as deficiências que não são abrangidas por nenhum curso
SELECT d.cid
    FROM deficiencia d
    left join curso c ON c.deficiencia = d.cid
    WHERE c.cid IS NULL;

-- Listar deficiências E se tiver seus respectivos cursos
-- Foi utilizado um inner join entre as tabelas deficiência e curso para conseguir listar as deficiências que são abrangidas por algum curso
SELECT d.cid, c.nome 
    FROM deficiencia d
    LEFT JOIN curso c ON c.deficiencia = d.cid;

-- Listar todas AS aulas oferecidas em 2020 que usaram mais de dois recursos:
-- Foi utilizado técnicas de agregação para conseguir listar as aulas que usaram mais de dois recursos
SELECT A.id, A.oferecimento, A.data_hora_inicio, A.data_hora_fim, A.sitio, A.numeracao
    FROM Aula A
    INNER JOIN Oferecimento O ON A.oferecimento = O.num_contrato
    INNER JOIN Aula_Recurso AR ON A.id = AR.aula
    INNER JOIN Recurso R ON AR.recurso = R.num_patrimonio
    WHERE EXTRACT(YEAR FROM A.data_hora_inicio) = 2020
    GROUP BY A.id, A.oferecimento, A.data_hora_inicio, A.data_hora_fim, A.sitio, A.numeracao
    HAVING COUNT(R.num_patrimonio) > 2;

-- Listar alunos que são abrangidos por um curso específico:
SELECT A.cpf, A.deficiencia, A.grau, A.nome, A.atestado, A.telefone_fixo, A.telefone_celular
    FROM Aluno A
    INNER JOIN Curso C ON A.deficiencia = C.deficiencia
    WHERE C.nome = 'Introdução à Informática';

-- Listar os recursos que um oferecimento usa:
-- Foi utilizado um inner join entre as tabelas Recurso, Aula_Recurso, Aula e Oferecimento para conseguir listar os recursos que um oferecimento usa    
SELECT R.num_patrimonio, R.tipo, R.nome
    FROM Recurso R
    INNER JOIN Aula_Recurso AR ON R.num_patrimonio = AR.recurso
    INNER JOIN Aula A ON AR.aula = A.id
    INNER JOIN Oferecimento O ON A.oferecimento = O.num_contrato
    WHERE O.num_contrato = 'CON0000001';