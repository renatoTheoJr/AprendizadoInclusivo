import cx_Oracle
def conectarBanco():
    dsn_tns = cx_Oracle.makedsn('orclgrad1.icmc.usp.br', '1521', service_name='pdb_elaine.icmc.usp.br')# if needed, place an 'r' before any parameter in order to address special characters such as '\'.
    user = 'seu usuario'
    senha = 'sua senha'
    conn = cx_Oracle.connect(user=user, password=senha, dsn=dsn_tns) 
    return conn
def fecharConexao(conn):
    conn.close()

def consultarAlunos(conn):
    c = conn.cursor()
    c.execute('select a.nome from aluno a') # use triple quotes if you want to spread your query across multiple lines
    for row in c:
        print (row[0]) # this only shows the first two columns. To add an additional column you'll need to add , '-', row[2], etc.


def menu():
    print("1 - Cadastrar Oferecimento")
    print("2 - Consultar todos os alunos")
    print("3 - Sair do sistema")
    result = input("Digite a opção desejada: ")
    return result
def main():
    print("Bem vindo ao sistema de aprendizado inclusivo")
    while(True):
        opcao = menu()
        if opcao == "1":
            print("Cadastrar Oferecimento")
        elif opcao == "2":
            print("Consultar todos os alunos")
            conn = conectarBanco()
            consultarAlunos(conn)
            fecharConexao(conn)
        elif opcao == "3":
            print("Sair do sistema")
            break
        else:
            print("Opção inválida")
    
if __name__ == "__main__":
    main()