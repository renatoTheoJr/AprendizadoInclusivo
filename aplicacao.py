import cx_Oracle
import os

def conectarBanco():
    dsn_tns = cx_Oracle.makedsn('orclgrad1.icmc.usp.br', '1521', service_name='pdb_elaine.icmc.usp.br')# if needed, place an 'r' before any parameter in order to address special characters such as '\'.
    user = 'a11796750'
    senha = '1401021013'
    conn = cx_Oracle.connect(user='a11796750', password='1401021013', dsn=dsn_tns) 
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
def menu():
    print('\n')
    print("1 - Cadastrar Oferecimento")
    print("2 - Consultar todos os alunos")
    print("3 - Consultar todos os oferecimentos")
    print("4 - Consultar todos os alunos que foram em todas as aulas de um oferecimento")
    print("5 - Limpar tela")
    print("6 - Sair do sistema")
    result = input("Digite a opção desejada: ")
    return result
def main():
    os.system('clear')  # on linux / os x
    print("                     Bem vindo ao sistema de aprendizado inclusivo")
    while(True):
        opcao = menu()
        if opcao == "1":
            print("Cadastrar Oferecimento")
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
            os.system('clear')  # on linux / os x
        elif opcao == "6":
            print("Sair do sistema")
            break
        else:
            print("Opção inválida")
    
if __name__ == "__main__":
    main()