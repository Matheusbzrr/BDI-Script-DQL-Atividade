select emp.nome "Nome Empregado", emp.cpf "CPF Empregado", date_format(emp.dataAdm, '%d/%m/%Y' ) "Data de Admissão", 
concat("R$ ", format(emp.salario, 2, 'de_DE')) "Salário", emp.Departamento_idDepartamento "Departamento",
	coalesce(tel.numero, 'Sem Telefone') "Número de Telefone"
    from empregado emp
		left join telefone tel 
			on tel.Empregado_cpf = emp.cpf
            where emp.dataAdm between '2023-01-01' and '2023-06-30' 
            order by emp.dataAdm desc;
   
   
-- select avg(emp.salario) "Média Salarial" from empregado emp; tireia media para ter certeza. A media foi 3360
select emp.nome "Nome Empregado", emp.cpf "CPF Empregado", date_format(emp.dataAdm, '%d/%m/%Y' ) "Data de Admissão", 
concat("R$ ", format(emp.salario, 2, 'de_DE')) "Salário", emp.Departamento_idDepartamento "Departamento",
	coalesce(tel.numero, 'Sem Telefone') "Número de Telefone"
		from empregado emp
			left join telefone tel
				on tel.Empregado_cpf = emp.cpf
			where emp.salario < (select avg(empMedia.salario) from empregado empMedia)
			order by emp.nome;
            
            
select dep.nome "Departamento", count(emp.cpf) "Quantidade de Empregados",concat("R$ ", format(avg(emp.salario), 2, 'de_DE'))  "Média Salarial", concat("R$ ", format(avg(emp.comissao), 2, 'de_DE')) "Média da Comissão"
            from empregado emp
            inner join departamento dep
				on dep.idDepartamento =emp.Departamento_idDepartamento
                group by dep.nome
                order by dep.nome;
                
select emp.nome "Nome Empregado",emp.cpf "CPF Empregado", emp.sexo "Sexo",concat("R$ ", format(emp.salario, 2, 'de_DE')) "Salário", count(vnd.idVenda) "Quantidade de Vendas", 
	concat("R$ ", format(sum(vnd.valor), 2, 'de_DE')) "Total Valor Vendido", concat("R$ ", format(sum(vnd.comissao), 2, 'de_DE')) "Total Comissão das Vendas"
		from empregado emp
			inner join venda vnd
				on emp.cpf = vnd.Empregado_cpf
                group by emp.nome, emp.cpf, emp.sexo, emp.salario
                order by count(vnd.idVenda);
                
select emp.nome "Nome Empregado",emp.cpf "CPF Empregado", emp.sexo "Sexo",concat("R$ ", format(emp.salario, 2, 'de_DE')) "Salário", count(vnd.idVenda) "Quantidade de Vendas com Serviço", 
	concat("R$ ", format(sum(vnd.valor), 2, 'de_DE')) "Total Valor Vendido com Serviço", concat("R$ ", format(sum(vnd.comissao), 2, 'de_DE')) "Total Comissão das Vendas com Serviço"
		from empregado emp
			inner join itensservico its
				on emp.cpf = its.Empregado_cpf
			inner join venda vnd
				on its.Venda_idVenda =vnd.idVenda
                group by emp.nome, emp.cpf, emp.sexo, emp.salario
                order by count(vnd.idVenda) desc;
                

                
select pt.nome "Nome do Pet", date_format( vnd.data, '%d/%m/%Y') "Data do Serviço", date_format(vnd.data, '%H:%i') "Horário", srv.nome "Nome do Serviço", count(its.quantidade) "Quantidade",
    sum(srv.valorVenda) "Valor", emp.nome"Empregado que realizou o Serviço"
	from 
		itensservico its
		inner join venda vnd 
			on its.Venda_idVenda = vnd.idVenda
		inner join servico srv 
			on its.Servico_idServico = srv.idServico 
		inner join pet pt 
			on its.PET_idPET = pt.idPET  
		inner join empregado emp 
			on vnd.Empregado_cpf = emp.cpf 
				group by 
					pt.nome, vnd.data, srv.nome, emp.nome
					order by 
						vnd.data DESC;  

select cli.nome "Cliente", date_format( vnd.data, '%d/%m/%Y') "Data do Serviço", date_format(vnd.data, '%H:%i') "Horário" ,concat("R$ ", format(vnd.valor, 2, 'de_DE')) "Valor", concat("R$ ", format(vnd.desconto, 2, 'de_DE')) "Desconto", 
    concat("R$ ", format((vnd.valor - vnd.desconto), 2, 'de_DE')) "Valor Final", emp.nome "Empregado que Realizou Venda" 
		from venda vnd
			inner join empregado emp 
				on vnd.Empregado_cpf = emp.cpf
            inner join  cliente cli
				on vnd.Cliente_cpf = cli.cpf
                order by vnd.data desc;
                
select srv.nome "Nome do Serviço", count(its.Venda_idVenda) "Quantidade Vendas", concat("R$ ", format(sum(srv.valorVenda * its.quantidade), 2, 'de_DE')) "Total Valor Vendido"
	from itensservico its
		inner join servico srv
			on its.Servico_idServico = srv.idServico
            group by srv.nome
            order by count(its.Venda_idVenda) desc
            limit 10;
            
select fp.tipo "Tipo Forma de Pagamento", count(fp.idFormaPgVenda) "Quantidade Vendas", concat("R$ ", format(sum(fp.valorPago), 2, 'de_DE')) "Valor Total Pago"
	from formapgvenda fp
            group by fp.tipo
            order by  count(fp.idFormaPgVenda) desc;
            

select date_format( vnd.data, '%d/%m/%Y') "Data da Venda",  count(vnd.idVenda) "Quantidade Vendas", concat("R$ ", format(sum(vnd.valor - vnd.desconto), 2, 'de_DE')) "Valor Total Pago"
	from venda vnd
		group by vnd.data
        order by vnd.data;
        
select pdt.nome "Nome do produto", concat("R$ ", format(pdt.precoCusto, 2, 'de_DE'))  "Valor do Produto", pdt.marca "Categoria do Produto", fnd.nome "Fornecedor", fnd.email "Email Fornecedor",
		coalesce(tel.numero, 'Sem Telefone') "Número de Telefone"
            from produtos pdt
				inner join itenscompra itc
					on itc.Produtos_idProduto = pdt.idProduto
				inner join compras cmp
					on cmp.idCompra = itc.Compras_idCompra
				inner join fornecedor fnd 
					on fnd.cpf_cnpj = cmp.Fornecedor_cpf_cnpj
				left join telefone tel 
					on tel.Fornecedor_cpf_cnpj = fnd.cpf_cnpj
                order by pdt.nome;

select pdt.nome "Nome Produto", count(ivp.Produto_idProduto) "Quantidade Total de Vendas", concat("R$ ", format( sum(pdt.valorVenda), 2, 'de_DE'))  "Valor Total Faturado em Vendas de Produtos"
	from produtos pdt 
		inner join itensvendaprod ivp
			on ivp.Produto_idProduto = pdt.idProduto 
		group by pdt.nome
        order by count(ivp.Produto_idProduto) desc;
