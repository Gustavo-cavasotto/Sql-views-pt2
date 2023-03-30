CREATE TABLE Clientes (
id INT NOT NULL PRIMARY KEY,
nome VARCHAR(50) NOT NULL
);

CREATE TABLE Livros (
id INT NOT NULL PRIMARY KEY,
titulo VARCHAR(50) NOT NULL,
valor_unit DECIMAL(10,2) NOT NULL
);

CREATE TABLE Autores (
id INT NOT NULL PRIMARY KEY,
nome VARCHAR(50) NOT NULL
);

CREATE TABLE Autores_livros (
id_autor INT NOT NULL,
id_livro INT NOT NULL,
PRIMARY KEY (id_autor, id_livro),
FOREIGN KEY (id_autor) REFERENCES Autores(id),
FOREIGN KEY (id_livro) REFERENCES Livros(id)
);

CREATE TABLE Vendas (
id INT NOT NULL PRIMARY KEY,
data DATE NOT NULL,
id_cliente INT NOT NULL,
FOREIGN KEY (id_cliente) REFERENCES Clientes(id)
);

CREATE TABLE vendas_livros (
id INT NOT NULL PRIMARY KEY,
id_livro INT NOT NULL,
qtd INT NOT NULL,
valor_unit DECIMAL(10,2) NOT NULL,
FOREIGN KEY (id_livro) REFERENCES Livros(id)
);



INSERT INTO Clientes (id, nome) VALUES
(1, 'João da Silva'),
(2, 'Maria Souza'),
(3, 'Pedro Oliveira');

INSERT INTO Livros (id, titulo, valor_unit) VALUES
(1, 'Dom Casmurro', 25.90),
(2, 'Memórias Póstumas de Brás Cubas', 30.50),
(3, 'O Cortiço', 19.99);

INSERT INTO Autores (id, nome) VALUES
(1, 'Machado de Assis'),
(2, 'Aluísio Azevedo');

INSERT INTO Autores_livros (id_autor, id_livro) VALUES
(1, 1),
(1, 2),
(2, 3);

INSERT INTO Vendas (id, data, id_cliente) VALUES
(1, '2022-03-25', 1),
(2, '2022-03-26', 2),
(3, '2022-03-27', 3);

INSERT INTO vendas_livros (id, id_livro, qtd, valor_unit) VALUES
(1, 1, 2, 25.90),
(2, 2, 1, 30.50),
(3, 3, 3, 19.99);


CREATE VIEW livros_mais_vendidos AS
SELECT livros.titulo, autores.nome, livros.valor_unit, vendas_livros.qtd
FROM autores
INNER JOIN autores_livros ON autores_livros.id_autor = autores.id
INNER JOIN livros ON livros.id = autores_livros.id_livro
INNER JOIN vendas_livros ON vendas_livros.id_livro = livros.id
GROUP BY livros.titulo
ORDER BY vendas_livros.qtd DESC;


CREATE VIEW autores_sem_vendas AS
SELECT autores.id, autores.nome
FROM autores
WHERE autores.id NOT IN (
    SELECT DISTINCT autores_livros.id_autor
    FROM autores_livros
    INNER JOIN vendas_livros ON vendas_livros.id_livro = autores_livros.id_livro
);

/* Listar os livros mais vendidos de todos os tempos, mostrando o título do livro, o número total de vendas e o valor 
total arrecadado com essas vendas.*/
CREATE VIEW livros_mais_vendidos AS
SELECT livros.titulo, SUM(vendas_livros.qtd) AS total_vendas, SUM(vendas_livros.qtd * livros.valor_unit) AS total_arrecadado
FROM livros
INNER JOIN vendas_livros ON vendas_livros.id_livro = livros.id
INNER JOIN vendas ON vendas.id = vendas_livros.id
GROUP BY livros.titulo
ORDER BY total_vendas DESC;



