function EqSolverSolve(inputFile, outputFile)
% function EqSolverSolve(inputFile, outputFile)
%
% % May 27, 2012
% % EE368 Final Project
% % Aman Sikka, Benny Wu
% %
% % Testing VL_MSER on Camera pictures
% 
%input_img_path = 'C:\wamp\www\upload\equation.txt';

% Read from input file, equation.txt

    fid = fopen(inputFile);
    if (fid == -1)
        disp('ERROR: Cannot open equation.txt');
        outputS = 'ERROR: Cannot read equation.';
    else
        li = 1;
        vars = [];     % Variables
        i=1;
        while 1
            %inLine = fgetl(fid);
            %disp(inLine)
            inLine = fgetl(fid);
            %disp(inLine)
            if ~ischar(inLine), break, end
            outLine = [];
            if ~isempty(inLine)
                for ini = 1:length(inLine)
                    % Add in '*' between a number and a character (a...z)
                    if (char(inLine(ini)) > 96) && (char(inLine(ini)) < 123)  %char is a...z                         
                        if char(inLine(ini)) == 120   %char is 'x', convert to '*'
                            inLine(ini) = '*';
                            outLine = [outLine '*'];
                        else
                            if isempty( strfind(vars, inLine(ini)) )         %New variable detected
                                vars = [vars char(inLine(ini))]; % Add to list of variables
                            end
                            if (ini > 1) && (char(inLine(ini-1)) > 47) && (char(inLine(ini-1)) < 58) %previous char is 0...9
                                outLine = [outLine '*' inLine(ini)];
                            else
                                outLine = [outLine inLine(ini)];
                            end
                        end
                    % Add in '^' for exponents
                    elseif (char(inLine(ini)) > 48) && (char(inLine(ini)) < 57) %char is 0...9
                        if (ini > 1) && (((char(inLine(ini-1)) > 96) && (char(inLine(ini-1)) < 123)) || (inLine(ini-1) == ')') )%previous char is a...z
                            outLine = [outLine '^' inLine(ini)];
                        else
                            outLine = [outLine inLine(ini)];
                        end
                    else
                        outLine = [outLine inLine(ini)];
                    end
                end
                % Store in MATLAB
                eval(sprintf('MATLABeqn.line%i= outLine;', li));        
                li = li + 1;
            end                    
            i = i+1;
            
            if inLine == ' ';
                li = li-1;
            end
        end
        fclose(fid);


        % Solve given equation, format output to single string
        switch length(vars)
            case 0
                try
                    S0 = eval(MATLABeqn.line1);

                    outputS = sprintf('%s', num2str(S0));
                    outputD = sprintf('%f', S0);
                catch e
                    disp('ERROR: Not a valid equation or expression.');
                    disp(getReport(e,'extended'));
                    outputS = 'ERROR: Not a valid equation or expression.';
                end
            case 1
                % Solve polynomial equation
                try
                    S1 = solve(MATLABeqn.line1);

                    % Format output into single string
                    outputS = [];
                    outputD = [];
                    for si = 1:length(S1)
                        outputS = [outputS sprintf(' %c = %s; ', vars(1), char(S1(si))) ];
                        outputD = [outputD sprintf(' %c = %s; ', vars(1), num2str(double(S1(si)))) ];
                    end
                catch e
                    disp('ERROR: Not a valid equation or expression.');
                    disp(getReport(e,'extended'));
                    outputS = 'ERROR: Not a valid equation or expression.';
                end
            case 2
                % Solve system of equations
                try
                    S2 = solve(MATLABeqn.line1, MATLABeqn.line2);

                    % Format output into single string
                    outputS = sprintf('%c = %s; %c = %s;', vars(1), char(S2.(vars(1))), vars(2), char(S2.(vars(2))));
                    outputD = sprintf('%c = %0.3f; %c = %0.3f;', vars(1), double(S2.(vars(1))), vars(2), double(S2.(vars(2))));
                catch e
                    disp('ERROR: Not a valid equation or expression.');
                    disp(getReport(e,'extended'));
                    outputS = 'ERROR: Not a valid equation or expression.';
                end
        end
    end

    % (4) Write output to file
        %fileID = fopen('C:\wamp\www\upload\EqSolverFinal.txt', 'w');
        fileID = fopen(outputFile, 'w');
        % If outputS is empty, something went wrong...
        if isempty(outputS)
            fprintf(fileID, 'ERROR: Something went wrong... Likely invalid equation or expression.');
        else
            fprintf(fileID, '%s', outputS);
        end
        fclose(fileID);

