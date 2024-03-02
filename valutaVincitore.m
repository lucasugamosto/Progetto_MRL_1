function Rt = valutaVincitore(At,ARand)
    %Funzione che restituisce il reward ottenuto all'istante t dal
    %giocatore 1 valutando l'azione presa da ogni giocatore
    % 1 = Sasso, 2 = Carta, 3 = Forbici, 4 = Spock, 5 = Lizard
    
    if (At == ARand)
        %Se entrambi scelgono la stessa azione allora il reward ottenuto
        %all'istante t dal giocatore 1 è 0
        Rt = 0;
    elseif (At ~= ARand)
        %Se i due giocatori scelgono azioni diverse tra loro allora si
        %hanno le seguenti conbinazioni ed il reward per il giocatore 1 
        %sarà 1 se vince, -1 altrimenti
        if ((At == 1) && (ARand == 5))
            Rt = 1;
        elseif ((At == 5) && (ARand == 4))
            Rt = 1;
        elseif ((At == 4) && (ARand == 3))
            Rt = 1;
        elseif ((At == 3) && (ARand == 2))
            Rt = 1;
        elseif ((At == 2) && (ARand == 1))
            Rt = 1;
        elseif ((At == 1) && (ARand == 3))
            Rt = 1;
        elseif ((At == 2) && (ARand == 4))
            Rt = 1;
        elseif ((At == 3) && (ARand == 5))
            Rt = 1;
        elseif ((At == 4) && (ARand == 1))
            Rt = 1;
        elseif ((At == 5) && (ARand == 2))
            Rt = 1;
        else
            %Tutti i restanti casi provocano la sconfitta del giocatore 1
            Rt = -1;
        end
    end    