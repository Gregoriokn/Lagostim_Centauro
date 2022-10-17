Trabalho Prático da Disciplina de Laboratório de Hardware
(V1) - Outubro de 2022
Eduardo Ferreira Valim, Gregório Koslinski Neto
1
Resumo. Este relatório descreve os passos concluídos na primeira vers ão do
projeto do trabalho prático da disciplina de Laborat ́orio de Hardware, que im-
plementa um SoC (System on a Chip) utilizando a Linguagem de Descric ̧  ̃ao de
Hardware VHDL.
1. V1
1.1. Entidade Mem ́oria
A entidade memoria foi criada como um vetor com cada posic ̧  ̃ao possuindo 1 byte. A
entidade memoria foi instanciada duas vezes na entidade soc para representar a mem ́oria
de instruc ̧  ̃oes (IMEM) e mem ́oria de dados (DMEM) do processador. Ambas as mem ́orias
est ̃ao conectadas a cpu. Por padr ̃ao, o barramento de dados lidos representado pelo sinal
data out retorna 4 bytes lidos a partir do enderec ̧o enviado no sinal data addr.
1.2. Testbench da Mem ́oria
O testbench da mem ́oria foi feito de forma que instancia a entidade memoria e faz um
teste de escrita e leitura na qual a escrita foi o bit 1 em todas as posic ̧  ̃oes da mem ́oria
sendo verificado com assert se em todas as posic ̧  ̃oes foi escrito com sucesso o bit 1.
1.3. Entidade Codec
A entidade codec foi constru ́ıda para 2 instruc ̧  ̃oes da cpu, sendo elas o In e Out na qual a
cpu manda 1 byte para a entidade codec que salva esse byte em um aquivo de sa ́ıda, caso
a cpu use o comando out o codec lˆe um byte de um arquivo de entrada e manda para a
cpu.
1.4. Testbench de Codec
O testbench do codec foi construido de forma que instancia a entidade codec, enviando 1
byte para que o codec guarde em um arquivo e receba o mesmo byte deste arquivo.
