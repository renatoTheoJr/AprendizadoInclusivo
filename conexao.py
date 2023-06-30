import cx_Oracle

def conectarBanco():
    dsn_tns = cx_Oracle.makedsn('orclgrad1.icmc.usp.br', '1521', service_name='pdb_elaine.icmc.usp.br') # se necessário, coloque um 'r' antes de qualquer parâmetro para lidar com caracteres especiais como '\'.
    user = 'a12543669'
    senha = 'a12543669'
    conn = cx_Oracle.connect(user=user, password=senha, dsn=dsn_tns) 
    return conn

def fecharConexao(conn):
    conn.close()

def consultarJogadores(conn):
    c = conn.cursor()
    c.execute('select nome from jogador') # use aspas triplas se quiser dividir sua consulta em várias linhas
    for row in c:
        print(row) # isso mostra apenas as duas primeiras colunas. Para adicionar uma coluna adicional, você precisará adicionar , '-', row[2], etc.

conn = conectarBanco()
consultarJogadores(conn)
fecharConexao(conn)
