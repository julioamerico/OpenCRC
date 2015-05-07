%Este script gera os padrões a serem utilizados para teste do módulo
%crc_parallel.
%Os resultados aqui gerados são carregados por tb_crc_serial.
display('Gerando padrões...');
PATTERN_VECTOR_NUMBER = 100;
PATTERN_POLYNOMIAL_NUMBER = 100;
FRAME_SIZE = 32;
CRC_SIZE = 32;
POLY_MAX_SIZE = CRC_SIZE + 1;

%Salva parâmetros da geraçao dos padrões
fid_config = fopen('crc_serial_gen.conf','w');
fprintf(fid_config, '`define PATTERN_VECTOR_NUMBER %d\n', PATTERN_VECTOR_NUMBER);
fprintf(fid_config, '`define FRAME_SIZE %d\n', FRAME_SIZE);
fprintf(fid_config, '`define CRC_SIZE %d\n', CRC_SIZE);
fprintf(fid_config, '`define MASK %d''h%s\n', CRC_SIZE, dec2hex(2^CRC_SIZE - 1));
fclose(fid_config);

fid_poly = fopen('crc_poly.bin','w');
fid_poly_size = fopen('crc_poly_size.bin','w');
fid = fopen('pattern_vector.bin','w');
for j = 1 : PATTERN_POLYNOMIAL_NUMBER
    poly_length = random('unid', POLY_MAX_SIZE - 2, 1, 1);
    
    poly_wo_degree_n = rem(random('unid', 10, 1, poly_length), 2);
    poly = [1 poly_wo_degree_n 1];

    leading_zeros = zeros(1, POLY_MAX_SIZE - length(poly));
    poly_size = zeros(1,CRC_SIZE);
    poly_size(CRC_SIZE + 2 - length(poly)) = 1;
    %Salva polinômio gerador
    fprintf(fid_poly, '%d', [leading_zeros poly]);
    fprintf(fid_poly, '\n');
    
    fprintf(fid_poly_size, '%d', poly_size);
    fprintf(fid_poly_size, '\n');

    %Cria o gerador de CRC
    crc_gen = comm.CRCGenerator(poly);

    %Calcula CRC para diveros padões gerados aleatoriamente
    for i = 1 : PATTERN_VECTOR_NUMBER
        %generate random stimulus
        crc_in = rem(random('unid', 10, 1, FRAME_SIZE), 2);
        crc_in = logical(crc_in');

        %compute the crc of stimulus
        code_word = step(crc_gen, crc_in);

        %Salva dados gerados
        crc_out = code_word(length(crc_in) + 1 : end);
        fprintf(fid, '%d',[code_word(1:length(crc_in))' leading_zeros crc_out']);
        fprintf(fid,'\n');
    end
end
fclose(fid_poly);
fclose(fid_poly_size);
fclose(fid);
display('Padrões Gerados com Sucesso');
    