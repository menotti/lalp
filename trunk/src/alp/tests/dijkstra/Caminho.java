package alp.tests.dijkstra;

import java.util.*;

public class Caminho {
	public static int INFINITY = Integer.MAX_VALUE;
	
	private No[] nos;
	private No[] N; // N�s cujo caminho m�nimo partindo da fonte j� s�o conhecidos
	
	public Caminho(No[] nos) {
		this.setNos(nos);
	}
	
	public No[] getNos() {
		return this.nos;
	}
	
	public void setNos(No[] nos) {
		this.nos = nos;
	}
	
	// Verifica se um determinado n� est� em N
	public boolean emN(No no) {
		for (int i = 0; i < N.length; i++) {
			if (no.compareTo(N[i]) == 0)
				return true;
		}
		
		return false;
	}
	
	public No[] menorCaminho(No origem, No destino) {
		int i = 0, j = 0;
		No menor = null, atual = null; // �ltimo n� adicionado a N
		
		// Inicializa��o
		N = new No[nos.length];
		N[j++] = origem;
		
		for (i = 0; i < nos.length; i++) {
			nos[i].setD(INFINITY);
			nos[i].setAnterior(null);
		}
		
		atual = origem;
		
		// Dist�ncia de um n� para ele mesmo � inexistente
		atual.setD(0); 
		
		No[] vizinhos = atual.getVizinhos();
		
		if (vizinhos == null)
			return null;
		
		for (i = 0; i < vizinhos.length; i++)
			vizinhos[i].setAnterior(atual);
		
		while (atual.compareTo(destino) != 0) {
			menor = null;
			
			for (i = 0; i < nos.length; i++) {
				if (!emN(nos[i])) {
					if (menor == null)
						menor = nos[i];
					
					if (atual.getD() + atual.getPeso(nos[i]) < nos[i].getD()) {
						if (atual.getPeso(nos[i]) < INFINITY) {
							nos[i].setD(atual.getD() + atual.getPeso(nos[i]));
							
							if (atual.getPeso(nos[i]) < INFINITY)
								nos[i].setAnterior(atual);
						}
					}
					
					if (nos[i].getD() < menor.getD()) {
						menor = nos[i];
					}
				}
			}
			
			atual = menor;
			N[j++] = atual;
		}
		
		Stack<No> pilha = new Stack<No>();
		No[] retorno = new No[N.length];
		atual = N[j - 1];
		i = 0;
		
		while (atual != null) {
			pilha.push(atual);
			atual = atual.getAnterior();
		}
		
		j = pilha.size();
		for (i = 0; i < j; i++)
			retorno[i] = (No)pilha.pop();
		
		return retorno;
	}
}
