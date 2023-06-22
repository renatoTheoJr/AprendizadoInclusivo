import cx_Oracle

dsn_tns = cx_Oracle.makedsn('orclgrad1.icmc.usp.br', '1521', service_name='pdb_elaine.icmc.usp.br')# if needed, place an 'r' before any parameter in order to address special characters such as '\'.
user = 'seu usuario'
senha = 'sua senha'
conn = cx_Oracle.connect(user=user, password=senha, dsn=dsn_tns) 
c = conn.cursor()
c.execute('select nome from jogador') # use triple quotes if you want to spread your query across multiple lines
for row in c:
    print (row) # this only shows the first two columns. To add an additional column you'll need to add , '-', row[2], etc.
conn.close()

