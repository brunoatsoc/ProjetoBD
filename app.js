/*
    Projeto de Banco de Dados feito por Vitor Coutinho Lima e Bruno Santos Costa

    Para iniciar o npm use este comando no terminal na pasta do seu projeto: npm init -y
    Para instalar as dependências nescessárias use o comando no terminal na pasta em que seu projeto está: npm install express ejs mysql
    Para executar esse codigo digite no terminal o comando: node app.js
    Para ver o resultado, vá no seu navegador e entre no link: http://localhost:3000
    Para finalizar clique em ctrl + c no terminal
*/

//Define configurações iniciais
const express = require("express");
const mysql = require("mysql");
const bodyParser = require("body-parser");

const app = express();
const port = 3000; //Porta que será usada

let clienteEmail = null; //Variavel que guarda o email do cliente que está usando a conta

//Configura o banco de dados MySQL
const connection = mysql.createConnection({
    host: "localhost", //Nome do servidor
    user: "root", //Usuario do servidor
    password: "1003200039", //Senha do servidor(No caso essa é a minha senha, você precisa colocar a senha que você configurou)
    database: "agencia_viagem", //Nome do banco de dados
});//Fim

//Avisa se a conexão foi bem sucedida
connection.connect((err) => {
    if(err){
        console.log("Erro ao conectar ao MySQL: " + err.stack); //Isso será impresso no console no caso de erro
        return;
    }

    console.log("Cenectado ao MsSQL com ID " + connection.threadId); //Isso será ipresso no console no caso de sucesso
});//Fim

//Configura o express
app.set("view engine", "ejs");
app.use(bodyParser.urlencoded({extended: true}));
app.use(express.static("public"));
//Fim

//Rotas
//Rota principal chama index.ejs
app.get('/', (req, res) => {
    res.render('index'); //Rederiza a pagina index.ejs no navegador
});//Fim

//Rota para a pagina de login
app.get("/loginPage", (req, res) => {
    res.render("login.ejs"); //Renderiza a pagina login.ejs no navegador
});//Fim

//Rota para a pagina de cadastro
app.post('/cadastro', (req, res) => {
    const { nome_completo, email, senha, cpf, user_name, idade } = req.body; //Esses dados vão vir do formulário que o usuario digitou
  
    //Verificar se o email, CPF ou nome de usuario já estão em uso
    connection.query('SELECT * FROM CLIENTE_CONTA WHERE user_name = ? OR email = ? OR cpf = ?', [user_name, email, cpf], (err, results) => {
        if(err) throw err;
  
        if(results.length > 0){
            //Se email, usuario ou CPF já está em uso, exibe mensagem de erro(vou adicionar uma pagina de erro aqui)
            res.send('Usiário já cadastrado. Por favor, escolha outro usuário.');
        }else{
            //Email não está em uso, então o cadastro pode ser feito
            const usuario = { nome_completo, email, senha, cpf, user_name, idade };

            //Comando insert para colocar os dados do usuario no banco de dados
            //No lugar da interrogação ficará as variaveis que estão dentro das chaves
            connection.query('INSERT INTO CLIENTE_CONTA SET ?', {nome_completo, email, senha, cpf, user_name, idade}, (err, results) => {
                if(err) throw err;
                res.redirect('/loginPage'); //Vai renderizar a pagina de login onde o usuario pode entrar na conta
            });
        }
    });
});//Fim

//Rota para a pagina de fazer login
app.post('/login', (req, res) => {
    const { email, senha } = req.body; //Traz do formulario o email e a senha do usuario
    clienteEmail = email; //Salva o email do usuario

    //Comando select para saber se as informações que o usuario digitou estão no banco de dados
    connection.query(
        'SELECT * FROM CLIENTE_CONTA WHERE email = ? AND senha = ?', [email, senha],
        (err, results) => {
            if(err) throw err;
  
            //Se estiver certo sera redirecionado para a pagina que mostra a lista de pacotes de viagem
            if(results.length > 0){
                res.send('<a href="lista">Lista</a>');
            }else{
                res.send('Credenciais inválidas!');
            }
        }
    );
});//Fim
  
//Rota para a pagina de mostrar a lista de pacotes disponiveis
app.get('/lista', (req, res) => {
    //Comando select com join para trazer as informações dos pacotes de viagens
    connection.query(`SELECT id_pacote, detalhes_pacote, destino, preco, nome_pacote, data_viagem, nome_fornecedor, contato_fornecedor, servico_fornecido
    FROM PACOTE_VIAGEM
    JOIN PARCERIA ON PACOTE_VIAGEM.id_pacote = PARCERIA.id_pacote_fk
    JOIN FORNECEDOR ON PARCERIA.id_fornecedor_fk = FORNECEDOR.id_fornecedor`, (err, results) => {
        if(err) throw err;
        res.render('lista', { pacotes: results }); //Vai renderizar a pagina de pacotes de viagem, os dados estão na variavel pacotes
    });
});//Fim

//Rota para a opção compra
app.post('/compra', (req, res) => {
    const { id_pacote } = req.body;
  
    //Verificar se o usuário está logado
    if(!clienteEmail){
        res.send('Você precisa estar logado para comprar um pacote de viagem.');
        return;
    }

    // Consultar o banco de dados para obter as informações do usuário pelo email
    connection.query(`SELECT cpf, user_name FROM CLIENTE_CONTA WHERE email = ?`, [clienteEmail], (err, results) => {
        if(err) throw err;

        if(results.length === 0){
            res.send('Usuário não encontrado.');
            return;
        }

        const {cpf, user_name } = results[0];

        //Faz insert na tabela compra
        connection.query('INSERT INTO COMPRA SET ?', { id_pacote_fk: id_pacote, cpf_fk: cpf, user_name_fk: user_name }, (err, results) => {
            if(err) throw err;
            res.send(`Compra realizada com sucesso! <a href="lista">Voltar para lista de pacotes</a>`); //Exibe manssagem e coloca um link para o usuario voltar a pagina de lista de pacotes
        });
    });
});//Fim

//Rota para ir para a pagina de comentários
//A sintaxe abaixo significa que a rota é /comentarios e dentro da URL passamos id_pacote para usarmos dentro da rota
app.get("/comentarios/:id_pacote", (req, res) => {
    const id_pacote = req.params.id_pacote; //Pega o valor de id pacote assado por parametro na URL

    //Select no banco de dados
    connection.query(
        `SELECT CLIENTE_CONTA.user_name, FEEDBACK_CLIENTE.data_comentario, FEEDBACK_CLIENTE.comentario, PACOTE_VIAGEM.nome_pacote
        FROM CLIENTE_CONTA
        JOIN POSTA ON CLIENTE_CONTA.cpf = POSTA.cpf_fk AND CLIENTE_CONTA.user_name = POSTA.user_name_fk
        JOIN FEEDBACK_CLIENTE ON POSTA.id_feedback_fk = FEEDBACK_CLIENTE.id_feedback
        LEFT JOIN PACOTE_VIAGEM ON FEEDBACK_CLIENTE.id_pacote_fk = PACOTE_VIAGEM.id_pacote
        WHERE PACOTE_VIAGEM.id_pacote = ?
        ORDER BY FEEDBACK_CLIENTE.data_comentario;`, [id_pacote],
        (err, results) => {
            if (err) throw err;
            res.render("comentarios", { comentarios: results, id_pacote }); //Renderiza a pagina comentarios.ejs com os dados do select
        }
    );
});//Fim

//Rota para postar comentario(ainda preciso consertar)
//Recebe id_pacote pelo paramentro da URL
app.post("/postar_comentario/:id_pacote", (req, res) => {
    const {comentario} = req.body;

    //Faz insert no banco de dados
    connection.query('INSERT INTO FEEDBACK_CLIENTE SET data_comentario = NOW(), comentario = ?, id_pacote_fk = ?', [comentario, req.params.id_pacote], (err1, results1) => {
        if(err1) throw err1;

        console.log(results1);

        //Faz um slect para pegar informações
        connection.query(`SELECT id_feedback FROM FEEDBACK_CLIENTE`, (err2, results2) => {
            if(err2) throw err2;

            const {id_feedback} = results2[results2.length - 1];

            console.log(results2[results2.length - 1]);

            //Faz outro select para pegar informações
            connection.query(`SELECT user_name, cpf FROM CLIENTE_CONTA`, (err3, results3) => {
                if(err3) throw err3;

                console.log(results3);

                const {user_name, cpf} = results3[0];

                connection.query(`INSERT INTO POSTA SET ?`, {cpf_fk: cpf, user_name_fk: user_name, id_feedback_fk: id_feedback});

                res.redirect("/comentarios/" + req.params.id_pacote); //Redireciona a pagina para comentarios.ejs
            });
        });
    });
});//Fim

//Inicia o servidor
app.listen(port, () => {
    console.log(`Servidor rodando em http://localhost:${port}`);
});//Fim