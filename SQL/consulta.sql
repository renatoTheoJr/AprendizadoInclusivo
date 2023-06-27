 -- Lista todos os alunos que não faltaram nenhuma aula do contrato CON0000001

select a.nome from aluno a where
not exists((
    select id from aula au where
    au.oferecimento = 'CON0000001')
    minus
    (
        select p.aula from presenca p where
        p.aluno = a.cpf
    )
)

-- Lista todos os alunos que frequentaram pelo menos uma aula de todos ofereciementos do professor 26576719000
select a.nome from aluno a where
not exists((
    select o.num_contrato from oferecimento o where
    o.professor = '48425678056')
    minus
    (
        select au.oferecimento from aula au where
        au.id in (select p.aula from presenca p where
        p.aluno = a.cpf)
    )
) 

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
