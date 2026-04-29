create database analise_leads
use analise_leads;

create table canais(
id int primary key,
nome varchar (50) not null
); 

insert into canais (id, nome)
values 
(1,'Instagram'),
(2,'Facebook'),
(3,'Google'),
(4,'Whatsapp'),
(5,'Site'),
(6,'Indicação');

create table profissao (
id int primary key,
nome varchar (50) not null, 
);

insert into profissao (id,nome)
values
(1,'Médico'),
(2,'Enfermeiro'),
(3,'Psicólogos'),
(4,'Fisioterapeuta');

create table leads(
id int primary key,
data_lead date not null,
data_conversao date,
canal_id int not null ,
regiao varchar(50),
profissao_id int not null,
situacao varchar (50) not null check (situacao in ('Convertido','Não Convertido')),
valor_venda decimal (10,2),

foreign key (canal_id) references canais(id),
foreign key (profissao_id) references profissao(id)
);

insert into leads(id, data_lead,data_conversao,canal_id,regiao,profissao_id,situacao,valor_venda)
Values
(1, '2026-01-01', '2026-01-03', 1, 'SP', 1, 'Convertido', 500),
(2, '2026-01-02', NULL, 2, 'RJ', 2, 'Não Convertido', 0),
(3, '2026-01-03', '2026-01-06', 3, 'MG', 3, 'Convertido', 700),
(4, '2026-01-04', NULL, 4, 'SP', 4, 'Não Convertido', 0),
(5, '2026-01-05', '2026-01-08', 5, 'RJ', 1, 'Convertido', 300),
(6, '2026-01-06', NULL, 6, 'MG', 2, 'Não Convertido', 0),
(7, '2026-01-10', '2026-01-12', 1, 'SP', 3, 'Convertido', 450),
(8, '2026-01-12', NULL, 2, 'RJ', 4, 'Não Convertido', 0),
(9, '2026-01-15', '2026-01-18', 3, 'MG', 1, 'Convertido', 900),
(10, '2026-01-18', NULL, 4, 'SP', 2, 'Não Convertido', 0),
(11, '2026-02-01', '2026-02-03', 5, 'RJ', 3, 'Convertido', 600),
(12, '2026-02-02', NULL, 6, 'MG', 4, 'Não Convertido', 0),
(13, '2026-02-04', '2026-02-06', 1, 'SP', 1, 'Convertido', 750),
(14, '2026-02-06', NULL, 2, 'RJ', 2, 'Não Convertido', 0),
(15, '2026-02-08', '2026-02-10', 3, 'MG', 3, 'Convertido', 200),
(16, '2026-02-10', NULL, 4, 'SP', 4, 'Não Convertido', 0),
(17, '2026-02-12', '2026-02-14', 5, 'RJ', 1, 'Convertido', 1000),
(18, '2026-02-15', NULL, 6, 'MG', 2, 'Não Convertido', 0),
(19, '2026-02-18', '2026-02-20', 1, 'SP', 3, 'Convertido', 550),
(20, '2026-02-20', NULL, 2, 'RJ', 4, 'Não Convertido', 0),
(21, '2026-03-01', '2026-03-03', 3, 'MG', 1, 'Convertido', 400),
(22, '2026-03-02', NULL, 4, 'SP', 2, 'Não Convertido', 0),
(23, '2026-03-04', '2026-03-06', 5, 'RJ', 3, 'Convertido', 850),
(24, '2026-03-06', NULL, 6, 'MG', 4, 'Não Convertido', 0),
(25, '2026-03-08', '2026-03-10', 1, 'SP', 1, 'Convertido', 300),
(26, '2026-03-10', NULL, 2, 'RJ', 2, 'Não Convertido', 0),
(27, '2026-03-12', '2026-03-14', 3, 'MG', 3, 'Convertido', 720),
(28, '2026-03-15', NULL, 4, 'SP', 4, 'Não Convertido', 0),
(29, '2026-03-18', '2026-03-20', 5, 'RJ', 1, 'Convertido', 650),
(30, '2026-03-20', NULL, 6, 'MG', 2, 'Não Convertido', 0);

-- leads por canal
select c.nome as canal,
count(*) as total_leads
from leads l
join canais c on l.canal_id = c.id
group by c.nome
order by total_leads desc;

--Taxa de conversão por canal
select c.nome,
count(*) as total,
sum(case when l.situacao='Convertido' then 1 else 0 end) as convertidos,
sum(case when l.situacao='Convertido' then 1 else 0 end) * 100/count(*) as taxa_conversao
from leads l
join canais c on l.canal_id=c.id
group by c.nome
order by taxa_conversao desc; 

-- Leads versus conversões por mês
select 
year (data_lead) as ano,
month (data_lead) as mês,
count(*) as leads,
sum (case when situacao = 'Convertido' then 1 else 0 end) as convertidos
from leads
group by year (data_lead), month (data_lead)
order by  ano, mês;

--Conversões por região
select 
regiao,
count(*) as total,
sum( case when situacao = 'Convertido' then 1 else 0 end) as convertidos,
sum( case when situacao = 'Não Convertido' then 1 else 0 end) as nao_convertidos
from leads
group by regiao
order by  convertidos desc;

--Conversões por profissão
select 
p.nome as profissao,
count(*) as total,
sum( case when l.situacao = 'Convertido' then 1 else 0 end) as convertidos,
sum( case when situacao = 'Não Convertido' then 1 else 0 end) as nao_convertidos
from leads l
join profissao p on l.profissao_id = p.id
group by p.nome
order by convertidos desc;

--Análise combinada (Região + Profissão)
select 
l.regiao,
p.nome as profissao,
count(*) as total,
sum( case when l.situacao = 'Convertido' then 1 else 0 end) as convertidos,
sum( case when situacao = 'Não Convertido' then 1 else 0 end) as nao_convertidos
from leads l
join profissao p on l.profissao_id = p.id
group by l.regiao,p.nome
order by convertidos desc
