function At = UCB(Q, N, c, counter)
    %Funzione che restituisce l'azione presa all'istante t dal giocatore 1

    %Al denominatore vi è la quantità "1+N" per risolvere un possibile
    %problema all'inizio, cioè quando N = 0
    newQ = Q + (c .* (sqrt(log(counter) ./ (1 + N))));

    %AIl giocatore 1 sceglie l'azione che massimizza la variabile "newQ"
    %Il terzo parametro, "first", risolve i conflitti nel caso ci siano
    %più elementi di Q con valore uguale, si prende quello con indice
    %più piccolo
    At = find(newQ == max(newQ),1,"first");
end