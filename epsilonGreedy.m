function At = epsilonGreedy(Q,epsilon)
    %Funzione che restituisce l'azione A da prendere all'istante t
    %utilizzando il metodo Epsilon-greedy
    A = length(Q);                          %Calcola il numero di azioni possibili

    %Con probabilità "epsilon" si sceglie l'azione in maniera casuale
    %dall'insieme delle azioni possibili (compresa quella che fa ottenere
    %reward migliore) mentre con probabilità "1 - epsilon" si prende
    %l'azione greedy, cioè quella che fa ottenere reward migliore
    casualValue = rand(1);                  %Genera un numero casuale tra 0 ed 1
    if (casualValue <= epsilon)
        At = randi(A);                      %Scelta dell'azione in modo casuale
    else
        %Il terzo parametro, "first", risolve i conflitti nel caso ci siano
        %più elementi di Q con valore uguale, si prende quello con indice
        %più piccolo
        At = find(Q == max(Q),1,"first");   %Scelta dell'azione che massimizza Q
    end
end