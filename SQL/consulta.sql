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