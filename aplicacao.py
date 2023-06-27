import cx_Oracle
import os
from datetime import datetime, timedelta

def conectarBanco():
    dsn_tns = cx_Oracle.makedsn('orclgrad1.icmc.usp.br', '1521', service_name='pdb_elaine.icmc.usp.br')# if needed, place an 'r' before any parameter in order to address special characters such as '\'.
    user = 'a11796750'
    senha = '1401021013'
    conn = cx_Oracle.connect(user=user, password=senha, dsn=dsn_tns) 
    return conn
def fecharConexao(conn):
    conn.close()

def consultarAlunos(conn):
    c = conn.cursor()
    c.execute('select a.nome from aluno a') # use triple quotes if you want to spread your query across multiple lines
    for row in c:
        print (row[0]) # this only shows the first two columns. To add an additional column you'll need to add , '-', row[2], etc.
def consultarOferecimento(conn):
    c = conn.cursor()
    c.execute('select o.num_contrato, o.curso from oferecimento o') # use triple quotes if you want to spread your query across multiple lines
    for row in c:
        print (f"Contrato: {row[0]} - Curso: {row[1]}") # this only shows the first two columns. To add an additional column you'll need to add , '-', row[2], etc. 

def exists(conn, query):
    c = conn.cursor()
    c.execute(query)
    return c.fetchone()
def consultarEscolas(conn):
    c = conn.cursor()
    c.execute('select e.cnpj, e.nome from escola e')
    for row in c:
        print(f"Escola : {row[1]} - CNPJ: {row[0]}")
def consultarCursos(conn): 
    c = conn.cursor()
    c.execute('select c.nome from curso c')
    for row in c:
        print(f"Curso: {row[0]}")
def consultarProfessores(conn):
    c = conn.cursor()
    c.execute('select p.cpf, p.nome from professor p')
    for row in c:
        print(f"Professor: {row[1]} - CPF: {row[0]}")
def consultarAlunosOferecimento(contrato, conn):
    c = conn.cursor()
    c.execute(f"select o.num_contrato from oferecimento o where o.num_contrato = '{contrato}'")
    if c.fetchone() is None:
        print("Contrato não existe")
        return
    c.execute(f"""select a.nome from aluno a where 
            not exists((
                select id from aula au where
                au.oferecimento = '{contrato}')
                minus
                (
                    select p.aula from presenca p where
                    p.aluno = a.cpf
                )
        )""")
    for row in c:
        print(row[0])
def cadastrarOferecimento(conn, escola, curso, professor, doacao, data_inicio, data_fim, num_contrato):
    c = conn.cursor()
    c.execute(f"""insert into oferecimento(num_contrato, escola, curso, professor, doacao, data_inicio, data_fim)
              values('{num_contrato}', '{escola}', '{curso}', '{professor}', {doacao}, 
              to_date('{data_inicio}', 'dd/mm/yyyy'), to_date('{data_fim}', 'dd/mm/yyyy'))""")
    conn.commit()
def menu():
    print('\n')
    print("1 - Cadastrar Oferecimento")
    print("2 - Consultar todos os alunos")
    print("3 - Consultar todos os oferecimentos")
    print("4 - Consultar todos os alunos que foram em todas as aulas de um oferecimento")
    print("5 - Consultar todos os cursos disponíveis")
    print("6 - Consultar todos os professores")
    print("7 - Consultar todas as escolas")
    print("8 - Limpar tela")
    print("9 - Sair do sistema")
    result = input("Digite a opção desejada: ")
    return result
def main():
    os.system('clear')  # on linux / os x
    print("                     Bem vindo ao sistema de aprendizado inclusivo")
    while(True):
        opcao = menu()
        if opcao == "1":
            print("Cadastrar Oferecimento")
            conn = conectarBanco()
            while(True):
                escolas = input("Digite o CNPJ da escola: ")
                if exists(conn, f"select e.cnpj from escola e where e.cnpj = '{escolas}'") is None:
                    print("\nEscola não cadastrada")
                    continue
                curso = input("Digite o nome do curso: ")
                duracao = exists(conn, f"select c.duracao from curso c where c.nome = '{curso}'")
                if duracao is None:
                    print("\nCurso não cadastrado")
                    continue
                duracao = duracao[0]
                professor = input("Digite o CPF do professor: ")
                if exists(conn, f"select p.cpf from professor p where p.cpf = '{professor}'") is None:
                    print("\nProfessor não cadastrado")
                    continue;
                doacao = input("Digite o valor da doação: ")
                if int(doacao) < 0:
                    print("\nValor da doação inválido")
                    continue;
                data_inicio = input("Digite a data de início (dd/mm/yyyy): ")
                try:
                    datetimeObje = datetime.strptime(data_inicio, '%d/%m/%Y')
                except ValueError:
                    print("\nData inválida")
                    continue;
                if datetimeObje < datetime.now():
                    print("\nData inválida")
                    continue;
                data_fim = datetimeObje + timedelta(weeks=duracao)
                num_contrato = input("Digite o número do contrato: ")
                if exists(conn, f"select o.num_contrato from oferecimento o where o.num_contrato = '{num_contrato}'") is True:
                    print("\nNúmero do contrato já existe")
                    continue;
                cadastrarOferecimento(conn, escolas, curso, professor, doacao, data_inicio, data_fim.strftime('%d/%m/%Y'), num_contrato)
                fecharConexao(conn)
                break;
                
        elif opcao == "2":
            print("\nConsultar todos os alunos")
            conn = conectarBanco()
            consultarAlunos(conn)
            fecharConexao(conn)
        elif opcao == "3":
            print("\nConsultar todos os oferecimentos")
            conn = conectarBanco()
            consultarOferecimento(conn)
            fecharConexao(conn)
        elif opcao == "4":
            print("\nConsultar todos os alunos que foram em todas as aulas de um oferecimento")
            contrato = input("Digite o número do contrato: ")
            conn = conectarBanco()
            consultarAlunosOferecimento(contrato, conn)
            fecharConexao(conn)
        elif opcao == "5":
            print('\nConsultar cursos disponíveis')
            conn = conectarBanco()
            consultarCursos(conn)
            fecharConexao(conn)
        elif opcao == "6":
            print('\nConsultar professores')
            conn = conectarBanco()
            consultarProfessores(conn)
            fecharConexao(conn)
        elif opcao == "7":
            print('\nConsultar escolas')
            conn = conectarBanco()
            consultarEscolas(conn)
            fecharConexao(conn)
        elif opcao == "8":
            os.system('clear')  # on linux / os x
        elif opcao == "9":
            print("Sair do sistema")
            break
        else:
            print("Opção inválida")
    
if __name__ == "__main__":
    main()