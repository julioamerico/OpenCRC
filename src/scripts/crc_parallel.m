%Grau dos polinômios suportados
poly_1 = 31;
poly_2 = 15;
poly_3  =  7;
poly_4  =  6;

%Polinômio gerador do CRC - configurável
%[p31 p30 ... p1 p0]
p = [zeros(1,27) 1 1 0 1 0];

c = zeros(poly_1 + 1, poly_1 + 1);

for i = poly_1 + 1 : poly_2 + 2
    for j = 1 : poly_1 + 1
        if(j == 1)
            c(poly_1 - i, j) = p(poly_1 - i);
        else
            c(poly_1 - i, j) = (j == poly_1 - i - 1);
        end
    end
end

for i = poly_2 + 1: poly_3 + 2
    for j = 1 : poly_1 + 1
        if(j == 1)
            c(poly_1 - i, j) = p(poly_1 - i)*p(1);
        else
            if(j == 16)
                c(poly_1 - i, j) = p(poly_1 - i)*~p(1);
            else
                c(poly_1 - i, j) = (j == poly_1 - i - 1);
            end
        end
    end
end

for i = poly_3 +1 : poly_4 + 2
    for j = 1 : poly_1 + 1
        if(j == 1)
            c(poly_1 - i, j) = p(poly_1 - i)*p(1);
        else
            if(j == 16)
                c(poly_1 - i, j) = p(poly_1 - i)*p(poly_1 - poly_2)*~p(1);
            else
                if(j == poly_3 + 1)
                    c(poly_1 - i, j) = p(poly_1 - i)*~p(poly_1 - poly_2)*~p(1);
                else
                    c(poly_1 - i, j) = (j == poly_1 - i - 1);
                end
            end
        end
    end
end


for i = poly_4 + 1: 1
    for j = 1 : poly_1 + 1
        if(j == 1)
            c(poly_1 - i, j) = p(poly_1 - i)*p(1);
        else
            if(j == 16)
                c(poly_1 - i, j) = p(poly_1 - i)*p(poly_1 - poly_2 + 1)*~p(1);
            else
                if(j == poly_3 + 1)
                    c(poly_1 - i, j) = p(poly_1 - i)*p(poly_1 - poly_3 + 1)*~p(poly_1 - poly_2 + 1)*~p(1);
                else
                    if(j == poly_4 + 1)
                        c(poly_1 - i, j) = p(poly_1 - i)*~p(poly_1 - poly_3 + 1)*~p(poly_1 - poly_2 + 1)*~p(1);
                    else
                        c(poly_1 - i, j) = (j == poly_1 - i - 1);
                    end
                end
            end
        end
    end
end