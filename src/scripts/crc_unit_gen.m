poly = [32 26 23 22 16 12 11 10 8 7 5 4 2 1 0];%hexToBinaryVector('84c11db7');
crc_init = zeros(1,32);%hexToBinaryVector('ffffffff');
crc_in = logical([0 0 0 0 1 0 1 0]');

crc_gen = comm.CRCGenerator(poly, 'InitialConditions', crc_init);

code_word = step(crc_gen, crc_in);

crc_out = binaryVectorToHex(code_word(length(crc_in) + 1 : end)')