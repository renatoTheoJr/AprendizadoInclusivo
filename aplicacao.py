import cx_Oracle
import os
from datetime import datetime, timedelta

def conectarBanco():
    # Conecta ao banco de dados Oracle
    dsn_tns = cx_Oracle.makedsn('orclgrad1.icmc.usp.br', '1521', service_name='pdb_elaine.icmc.usp.br') # se necessário, coloque um 'r' antes de qualquer parâmetro para tratar caracteres especiais como '\'.
    user = 'a11796750'
    senha = '1401021013'
    conn = cx_Oracle.connect(user=user, password=senha, dsn=dsn_tns) 
    return conn

def fecharConexao(conn):
    # Fecha a conexão com o banco de dados
    conn.close()

def consultarAlunos(conn):
    # Consulta todos os alunos no banco de dados e exibe seus nomes
    c = conn.cursor()
    c.execute('SELECT a.nome FROM aluno a') # use aspas triplas se quiser espalhar sua consulta por várias linhas
    for row in c:
        print (row[0]) # isso mostra apenas as duas primeiras colunas. Para adicionar uma coluna adicional, você precisa adicionar , '-', row[2], etc.
        
def consultarOferecimento(conn):
    # Consulta todos os oferecimentos no banco de dados e exibe seus números de contrato e cursos correspondentes
    c = conn.cursor()
    c.execute('SELECT o.num_contrato, o.curso FROM oferecimento o') # use aspas triplas se quiser espalhar sua consulta por várias linhas
    for row in c:
        print (f"Contrato: {row[0]} - Curso: {row[1]}") # isso mostra apenas as duas primeiras colunas. Para adicionar uma coluna adicional, você precisa adicionar , '-', row[2], etc. 

def exists(conn, query):
    # Executa uma consulta para verificar se uma determinada condição existe no banco de dados
    c = conn.cursor()
    c.execute(query)
    return c.fetchone()

def consultarEscolas(conn):
    # Consulta todas as escolas no banco de dados e exibe seus CNPJs e nomes correspondentes
    c = conn.cursor()
    c.execute('SELECT e.cnpj, e.nome FROM escola e')
    for row in c:
        print(f"Escola : {row[1]} - CNPJ: {row[0]}")
        
def consultarCursos(conn): 
    # Consulta todos os cursos no banco de dados e exibe seus nomes
    c = conn.cursor()
    c.execute('SELECT c.nome FROM curso c')
    for row in c:
        print(f"Curso: {row[0]}")
        
def consultarProfessores(conn):
    # Consulta todos os professores no banco de dados e exibe seus CPFs e nomes correspondentes
    c = conn.cursor()
    c.execute('SELECT p.cpf, p.nome FROM professor p')
    for row in c:
        print(f"Professor: {row[1]} - CPF: {row[0]}")
        
def consultarAlunosOferecimento(contrato, conn):
    # Consulta todos os alunos que compareceram a todas as aulas de um determinado contrato de oferecimento
    c = conn.cursor()
    c.execute(f"SELECT o.num_contrato FROM oferecimento o WHERE o.num_contrato = '{contrato}'")
    
    if c.fetchone() is None:
        print("Contrato não existe")
        return
    
    c.execute(f"""SELECT a.nome FROM aluno a WHERE 
            NOT EXISTS((
                SELECT id FROM aula au WHERE
                au.oferecimento = '{contrato}')
                minus
                (
                    SELECT p.aula FROM presenca p WHERE
                    p.aluno = a.cpf
                )
        )""")
    for row in c:
        print(row[0])
        
def cadastrarOferecimento(conn, escola, curso, professor, doacao, data_inicio, data_fim, num_contrato):
    # Cadastra um novo oferecimento no banco de dados
    c = conn.cursor()
    c.execute(f"""insert into oferecimento(num_contrato, escola, curso, professor, doacao, data_inicio, data_fim)
              values('{num_contrato}', '{escola}', '{curso}', '{professor}', {doacao}, 
              to_date('{data_inicio}', 'dd/mm/yyyy'), to_date('{data_fim}', 'dd/mm/yyyy'))""")
    conn.commit()
    
def menu():
    # Exibe o menu principal
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
    os.system('clear')  # no linux / os x
    print("                     Bem vindo ao sistema de aprendizado inclusivo")
    
    while(True):
        opcao = menu()
        
        if opcao == "1":
            print("Cadastrar Oferecimento")
            conn = conectarBanco()
            
            while(True):
                escolas = input("Digite o CNPJ da escola: ")
                if exists(conn, f"SELECT e.cnpj FROM escola e WHERE e.cnpj = '{escolas}'") is None:
                    print("\nEscola não cadastrada")
                    continue
                
                curso = input("Digite o nome do curso: ")
                duracao = exists(conn, f"SELECT c.duracao FROM curso c WHERE c.nome = '{curso}'")
                
                if duracao is None:
                    print("\nCurso não cadastrado")
                    continue
                
                duracao = duracao[0]
                professor = input("Digite o CPF do professor: ")
                
                if exists(conn, f"SELECT p.cpf FROM professor p WHERE p.cpf = '{professor}'") is None:
                    print("\nProfessor não cadastrado")
                    continue
                
                doacao = input("Digite o valor da doação: ")
                if int(doacao) < 0:
                    print("\nValor da doação inválido")
                    continue
                data_inicio = input("Digite a data de início (dd/mm/yyyy): ")
                
                try:
                    datetimeObje = datetime.strptime(data_inicio, '%d/%m/%Y')
                except ValueError:
                    print("\nData inválida")
                    continue
                
                if datetimeObje < datetime.now():
                    print("\nData inválida")
                    continue
                
                data_fim = datetimeObje + timedelta(weeks=duracao)
                num_contrato = input("Digite o número do contrato: ")
                
                if exists(conn, f"SELECT o.num_contrato FROM oferecimento o WHERE o.num_contrato = '{num_contrato}'") is True:
                    print("\nNúmero do contrato já existe")
                    continue
                
                cadastrarOferecimento(conn, escolas, curso, professor, doacao, data_inicio, data_fim.strftime('%d/%m/%Y'), num_contrato)
                fecharConexao(conn)
                break
                
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
            os.system('clear')  # no linux / os x
            
        elif opcao == "9":
            print("Sair do sistema")
            break
        
        else:
            print("Opção inválida")
    
if __name__ == "__main__":
    main()
