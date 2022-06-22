function quaternions = angulosEulerParaQuaternions (anguloRotacao1, anguloRotacao2, anguloRotacao3)
global sequenciadeRotacao
matrizRotacao = angulosEulerParaMatrizRotacao (anguloRotacao1, anguloRotacao2, anguloRotacao3);
quaternions = matrizRotacaoParaQuaternions (matrizRotacao);
endfunction

