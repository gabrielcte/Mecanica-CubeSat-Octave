# Mecanica-CubeSat-Octave

O presente repositório contem meus códigos em Octave, das formulações que adaptei ou desenvolvi para a modelagem de um CubeSat. Essa modelagem se baseia na bibliografia citada abaixo e abrange principalmente a mecânica da trajetória e rotação de um corpo rígido em órbita baixa.
O intuito do modelo é ser uma base para uso de interessados no assunto e tem uma abordagem didática para futuros desenvolvimentos.

> Esse código foi desenvolvido para meu trabalho de conlusão do curso de graduação na engenharia Aeroespacial - UFABC.

## Octave

Foi usado o Octave como linguagem de programação, por ser uma alternativa OpenSource e ter similaridade com o Matlab, que é amplamente usada no setor aeroespacial. Se viu necessário tambem o uso de pacotes extras, que não foram desenvolvidos pelo autor. A seguir os links para baixar essa ferramenta e os adicionais:

[GNU Octave](https://octave.org/)

[GNU Octave: extra packages](https://octave.sourceforge.io/)

## Bibliografia Utilizada

As formulações para a mecânica orbital e mecânica de dois corpos é muito grande para ser contida em um único livro. Para tal foi usado um conjunto de livros alguns oferecem melhor visualização dos conceitos, outros formulações mais compreensiveis e ainda aqueles que auxiliam com códigos. Foram eles:


-> Funadamentos de Astronáutica, Volume 1, Sandro S. Fernandes e Maria C. F. P. Zanardi, Editora UFABC, 2018;

-> Understanding Space: An Introduction to Astronautics, Jerry J. Sellers, McGraw-Hill Companies, Inc, 2005;

-> Spacecraft Attitude Determination and Control, James R. Wetz, Springer Science & Business Media, 1978;

-> Space Vehicle Dynamics and Control, Bong Wie, American Institute of Aeronautics and Astronautics, Inc, 2008;


## Desenvolvimento

### Sistema de referência de Coordenadas e Tempo
Para o desenvolvimento das formulações mecanicas foram escolhidos os senguintes sistemas de coordenada:

-> Sistema de Coordenadas Geocentrico-Equatorial Inercial;
-> Sistema de Coordenadas Orbital;
-> Sistema de Coordenadas Fixo no Corpo;
-> Sistema de Coordenadas Geográficas

Sistema de referencia de tempo:

-> J2000: Definido como o equador médio e equinocio médio às 12:00 do Tempo Terrestre no dia 1º de Janeiro de 2000.

## Stanford Honor Code

"We strongly encourage students to form study groups, and discuss the lecture videos (including in-video questions). We also encourage you to get together with friends to watch the videos together as a group. However, the answers that you submit for the review questions should be your own work. For the programming exercises, you are welcome to discuss them with other students, discuss specific algorithms, properties of algorithms, etc.; we ask only that you not look at any source code written by a different student, nor show your solution code to other students."
