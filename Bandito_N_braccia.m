%Luca Sugamosto, matricola 0324613
%Mattia Quadrini, matricola 0334381

%Assignment 1: Dato il modello di gioco forbici,carta,sasso,Lizard,Spock,
%effetturare le seguenti operazioni:
    %1) Scegliere ripetutamente con quali azioni giocare
    
    %2) Il giocatore avversario gioca un'azione in modo casuale

    %3) Si ottiene reward +1 se si vince e -1 se si perde, 0 se si pareggia

    %4) L'obiettivo è ottenere il massimo reward atteso possibile;
    
    %5) Analizzare i risultati del valore atteso del reward per ogni azione
%%

%Epsilon-greedy sample-average
%-----------------------------
clear
close all
clc

fprintf("Ordine delle azioni nell'insieme A: ");
disp('1: Sasso, 2: Carta, 3: Forbici, 4: Spock, 5: Lizard');

%La seguente funzione è utile per la generazioni di numeri randomici; 
%ad ogni valore numerico di input è associata una certa sequenza di numeri
%casuali, quindi per cambiare i valori si varia l'input
rng(1);

% 1 = Sasso, 2 = Carta, 3 = Forbici, 4 = Spock, 5 = Lizard
A = 5;                      %Numero di azioni possibili

%Probabilità (epsilon) con cui si sceglie se prendere l'azione greedy
%(azione che fa ottenere migliore reward) o un'azione casuale in A.
epsilon = 0.50;             %Valore di probabilità

%Inizializzo il vettore delle stime del valore dell'azione che viene poi
%aggiornato effettuando una media aritmetica dei reward
Q = zeros(A,1);
%Inizializzo il vettore che tiene traccia per ogni azione del numero di
%volte che questa viene presa
N = zeros(A,1);

%Definisco un numero di azioni sufficientemente grande così da garantire
%che per istanti di tempi grandi le stime dei valori di azione siano uguale
%ai valori delle azioni q(a).
numIteration = 100000;      %Numero di iterazioni totali
counter = 0;                %Contatore delle iterazioni considerate

finalR = 0;                 %Valore del ritorno alla fine del loop
initialQ = Q;               %Salvo il valore di partenza della variabile Q
andamentoQ = zeros(A,numIteration);         %Vettore che mantiene traccia di Q nel tempo (usato per il plot)

while (counter < numIteration)
    %Scelta dell'azione da prendere all'istante t dai due giocatori
    At = epsilonGreedy(Q,epsilon);          %Azione presa all'istante t dal giocatore 1
    ARand = randi(A);                       %Azione presa all'istante t dal giocatore 2
    
    %Calcolo della ricompensa per il giocatore 1
    Rt = valutaVincitore(At,ARand);         %Ricompensa all'istante t del giocatore 1
    finalR = finalR + Rt;                   %Aggiornamento della ricompensa totale

    %Incremento delle variabili N e Q relative solo all'azione considerata
    %dal giocatore 1, mentre il resto rimane invariato
    N(At,1) = N(At,1) + 1;                      
    Q(At,1) = Q(At,1) + ((1 / N(At,1)) * (Rt - Q(At,1)));
    
    counter = counter + 1;                  %Aggiornamento del contatore delle iterazioni
    for i = 1:A
        andamentoQ(i,counter) = Q(i,1);     %Inserimento dei nuovi dati nel vettore
    end
end

figure(1)
stem(N,'filled','-');
grid on
title('Epsilon-greedy algorithm');

time = 0:1:numIteration;
andamentoQ = horzcat(initialQ,andamentoQ);

figure(2)
plot(time, andamentoQ, LineWidth = 1);
grid on
title('andamento del valore delle azioni Q');
legend('Q(1)','Q(2)','Q(3)','Q(4)','Q(5)');

fprintf("Reward finale per il giocatore 1: ");
disp(finalR);

%%

%Upper confidence bound - optimistic initialization - constant step size
%-----------------------------------------------------------------------
%OPTIMISTIC INITIALIZATION: consiste nell'assegnare valori alti alle
%stime del valore delle azioni Q così che all'inizio del loop tutte le 
%azioni vengono considerate per un certo numero di volte 

%CONSTANT STEP SIZE: questa scelta del passo di aggiornamento potrebbe non
%rispettare le condizioni di convergenza ma è utile per problemi non
%stazionari
clear
close all
clc

fprintf("Ordine delle azioni nell'insieme A: ");
disp('1: Sasso, 2: Carta, 3: Forbici, 4: Spock, 5: Lizard');

rng(2);

% 1 = Sasso, 2 = Carta, 3 = Forbici, 4 = Spock, 5 = Lizard
A = 5;                      %Numero di azioni possibili

alpha = 0.50;              %Inizializzazione del constant step-size
c = 0.75;                  %Inizializzazione del grado di esplorazione

%Inizializzo il vettore delle stime del valore dell'azione che viene poi
%aggiornato effettuando una media aritmetica dei reward
%Q = zeros(A,1);
Q = 10*ones(A,1);
%Inizializzo il vettore che tiene traccia per ogni azione del numero di
%volte che questa viene presa
N = zeros(A,1);

%Definisco un numero di azioni sufficientemente grande così da garantire
%che per istanti di tempi grandi le stime dei valori di azione siano uguale
%ai valori delle azioni q(a).
numIteration = 100000;      %Numero di iterazioni totali
counter = 0;                %Contatore delle iterazioni considerate

finalR = 0;                 %Valore del ritorno alla fine del loop
initialQ = Q;               %Salvo il valore di partenza della variabile Q
andamentoQ = zeros(A,numIteration);         %Vettore che mantiene traccia di Q nel tempo (usato per il plot)

while (counter < numIteration)
    counter = counter + 1;                  %Aggiornamento del contatore delle iterazioni
    
    %Scelta dell'azione da prendere all'istante t dai due giocatori
    At = UCB(Q,N,c,counter);                %Azione presa all'istante t dal giocatore 1     
    ARand = randi(A);                       %Azione presa all'istante t dal giocatore 2

    %Calcolo della ricompensa per il giocatore 1
    Rt = valutaVincitore(At,ARand);         %Ricompensa all'istante t del giocatore 1
    finalR = finalR + Rt;                   %Aggiornamento della ricompensa totale

    %Incremento delle variabili N e Q relative solo all'azione considerata
    %dal giocatore 1, mentre il resto rimane invariato
    N(At,1) = N(At,1) + 1;                      
    Q(At,1) = Q(At,1) + (alpha .* (Rt - Q(At,1)));

    for i = 1:A
        andamentoQ(i,counter) = Q(i,1);     %Inserimento dei nuovi dati nel vettore
    end
end

figure(1)
stem(N,'filled','-');
grid on
title('UCB algorithm with optimistic initialization and costant step-size');

time = 0:1:numIteration;
andamentoQ = horzcat(initialQ,andamentoQ);

figure(2)
plot(time, andamentoQ, LineWidth = 1);
grid on
title('andamento del valore delle azioni Q');
legend('Q(1)','Q(2)','Q(3)','Q(4)','Q(5)');

fprintf("Reward finale per il giocatore 1: ");
disp(finalR);

%%

%Upper confidence bound - optimistic initialization - variable step size
%-----------------------------------------------------------------------
%OPTIMISTIC INITIALIZATION: consiste nell'assegnare valori alti alle
%alle stime del valore dell'azione Q così che all'inizio del loop tutte le 
%azioni vengono prese un certo numero di volte

%VARIABLE STEP SIZE: soddisfa le condizioni di convergenza
clear
close all
clc

fprintf("Ordine delle azioni nell'insieme A: ");
disp('1: Sasso, 2: Carta, 3: Forbici, 4: Spock, 5: Lizard');

rng(5);

% 1 = Sasso, 2 = Carta, 3 = Forbici, 4 = Spock, 5 = Lizard
A = 5;                      %Numero di azioni possibili

c = 0.75;                   %Inizializzazione del grado di esplorazione

%Inizializzo il vettore delle stime del valore dell'azione che viene poi
%aggiornato effettuando una media aritmetica dei reward
% Q = zeros(A,1);
Q = 10*ones(A,1);
%Inizializzo il vettore che tiene traccia per ogni azione del numero di
%volte che questa viene presa
N = zeros(A,1);

%Definisco un numero di azioni sufficientemente grande così da garantire
%che per istanti di tempi grandi le stime dei valori di azione siano uguale
%ai valori delle azioni q(a).
numIteration = 100000;      %Numero di iterazioni totali
counter = 0;                %Contatore delle iterazioni considerate

finalR = 0;                 %Valore del ritorno alla fine del loop
initialQ = Q;               %Salvo il valore di partenza della variabile Q
andamentoQ = zeros(A,numIteration);         %Vettore che mantiene traccia di Q nel tempo (usato per il plot)

while (counter < numIteration)
    counter = counter + 1;                  %Aggiornamento del contatore delle iterazioni
    
    %Scelta dell'azione da prendere all'istante t dai due giocatori
    At = UCB(Q,N,c,counter);                %Azione presa all'istante t dal giocatore 1     
    ARand = randi(A);                       %Azione presa all'istante t dal giocatore 2

    %Calcolo della ricompensa per il giocatore 1
    Rt = valutaVincitore(At,ARand);         %Ricompensa all'istante t del giocatore 1
    finalR = finalR + Rt;                   %Aggiornamento della ricompensa totale

    %Incremento delle variabili N e Q relative solo all'azione considerata
    %dal giocatore 1, mentre il resto rimane invariato
    N(At,1) = N(At,1) + 1;                      
    Q(At,1) = Q(At,1) + ((1 / N(At,1)) .* (Rt - Q(At,1)));

    for i = 1:A
        andamentoQ(i,counter) = Q(i,1);     %Inserimento dei nuovi dati nel vettore
    end
end

figure(1)
stem(N,'filled','-');
grid on
title('UCB algorithm with optimistic initialization and variable step-size');

time = 0:1:numIteration;
andamentoQ = horzcat(initialQ,andamentoQ);

figure(2)
plot(time, andamentoQ, LineWidth = 1);
grid on
title('andamento del valore delle azioni Q');
legend('Q(1)','Q(2)','Q(3)','Q(4)','Q(5)');

fprintf("Reward finale per il giocatore 1: ");
disp(finalR);

%%

%Preferenze updates
%------------------
clear
close all
clc

fprintf("Ordine delle azioni nell'insieme A: ");
disp('1: Sasso, 2: Carta, 3: Forbici, 4: Spock, 5: Lizard');

rng(10);

% 1 = Sasso, 2 = Carta, 3 = Forbici, 4 = Spock, 5 = Lizard
A = 5;                      %Numero di azioni possibili

alpha = 0.500;               %Inizializzazione del constant step-size
averageR = 0;                %Inizializzazione della ricompensa media

%Inizializzo il vettore che tiene traccia per ogni azione del numero di
%volte che questa viene presa
N = zeros(A,1);
%Inizializzo il vettore che tiene traccia per ogni azione della sua
%preferenza (inizialmente questo valore è uguale per tutte)
H = zeros(A,1);

%Definisco un numero di azioni sufficientemente grande così da garantire
%che per istanti di tempi grandi le stime dei valori di azione siano uguale
%ai valori delle azioni q(a).
numIteration = 100000;      %Numero di iterazioni totali
counter = 0;                %Contatore delle iterazioni considerate

finalR = 0;                 %Valore del ritorno alla fine del loop
initialH = H;               %Salvo il valore di partenza della variabile Q
andamentoH = zeros(A,numIteration);         %Vettore che mantiene traccia di Q nel tempo (usato per il plot)

while (counter < numIteration)
    counter = counter + 1;                  %Aggiornamento del contatore delle iterazioni

    %Scelta dell'azione da prendere all'istante t dai due giocatori
    At = preferenceUpdates(H);              %Azione presa all'istante t dal giocatore 1     
    ARand = randi(A);                       %Azione presa all'istante t dal giocatore 2

    %Calcolo della ricompensa per il giocatore 1
    Rt = valutaVincitore(At,ARand);         %Ricompensa all'istante t del giocatore 1
    finalR = finalR + Rt;                   %Aggiornamento della ricompensa totale

    %Aggiorno la media dei reward ottenuti finora
    averageR = averageR + ((Rt - averageR) ./ counter);
    
    %Calcolo della preferenze associate ad ogni azione tramite la
    %distribuzione soft-max (utile per l'aggiornamento del vettore H)
    pi = softmax(H);

    %Aggiornamento del valore di preferenza dell'azione presa all'istante t
    H(At,1) = H(At,1) + (alpha .* (Rt - averageR) .* (1 - pi(At,1)));
    %Aggiornamento del vettore N relativo all'azione presa all'istante t
    N(At,1) = N(At,1) + 1;

    for i = 1:A
        %Aggiornamento del valore di preferenza di tutte le azioni non
        %prese all'istante t
        if (i ~= At)
            H(i,1) = H(i,1) - (alpha .* (Rt - averageR) .* pi(i,1));
        end
    end

    for i = 1:A
        andamentoH(i,counter) = H(i,1);     %Inserimento dei nuovi dati nel vettore
    end
end

figure(1)
stem(N,'filled','-');
grid on
title('Preference updates algorithm');

time = 0:1:numIteration;
andamentoH = horzcat(initialH,andamentoH);

figure(2)
plot(time, andamentoH, LineWidth = 1);
grid on
title('andamento del valore delle preferenze H');
legend('H(1)','H(2)','H(3)','H(4)','H(5)');

fprintf("Reward finale per il giocatore 1: ");
disp(finalR);
