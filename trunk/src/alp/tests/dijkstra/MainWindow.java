package alp.tests.dijkstra;

import java.awt.BorderLayout;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Vector;

import javax.swing.ComboBoxModel;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JEditorPane;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextField;
import javax.swing.event.ListDataListener;
import javax.swing.text.html.HTMLEditorKit;


public class MainWindow extends JFrame {
	private static final long serialVersionUID = -6059524383906734318L;
	
	private BorderedPanel pnNovoNo;
	private BorderedPanel pnAresta;
	private BorderedPanel pnLog;
	
	private JComboBox cbDe;
	private JComboBox cbAte;
	
	private JButton btnCriarAresta;
	private JButton btnRemoverAresta;
	private JButton btnCriarNo;
	private JButton btnRemoverNo;
	private JButton btnCalcular;
	
	private JButton btnSobre;
	private JButton btnSair;
	
	private Vector<Aresta> arestas = new Vector<Aresta>();
	private Vector<No> nos = new Vector<No>();
	
	private StringBuffer log = new StringBuffer();
	
	private JTextField txtNomeNo;
	private JTextField txtPeso;
	
	private JEditorPane txtLog;
	
	public MainWindow() {
		super("Algoritmo de Dijkstra");
		
		this.inicializarComponentes();
		this.setDefaultCloseOperation(EXIT_ON_CLOSE);
		this.setResizable(false);
	}
	
	public void inicializarComponentes() {
		Container contentPane = this.getContentPane();
		
		JPanel pnPainels = new JPanel();
		pnPainels.setLayout(new BorderLayout());
		
		ButtonListener ouvinte = new ButtonListener();
		
		pnNovoNo = new BorderedPanel("N�s");
		pnAresta = new BorderedPanel("Arestas");
		pnLog = new BorderedPanel("Log");
		JPanel pnNorth = new JPanel();
		
		GridBagConstraints c = null;
		
		pnNovoNo.setLayout(new GridBagLayout());
		pnAresta.setLayout(new GridBagLayout());
		pnLog.setLayout(new BorderLayout());
		
		JLabel lbNome = new JLabel("Nome:");
		
		txtNomeNo = new JTextField();
		
		btnCriarNo = new JButton("Criar");
		btnCriarNo.setMnemonic('C');
		btnCriarNo.setToolTipText("Cria um n� com o nome especificado");
		btnCriarNo.addActionListener(ouvinte);
		
		btnRemoverNo = new JButton("Remover");
		btnRemoverNo.setMnemonic('R');
		btnRemoverNo.setToolTipText("Remove um n� existente com o nome especificado.");
		btnRemoverNo.addActionListener(ouvinte);
		
		c = new GridBagConstraints(0, 0, 1, 1, 40, 100, GridBagConstraints.SOUTHWEST, GridBagConstraints.HORIZONTAL, new Insets(2, 2, 2, 2), 0, 0);
		pnNovoNo.add(lbNome, c);
		
		c = new GridBagConstraints(0, 1, 2, 1, 40, 100, GridBagConstraints.WEST, GridBagConstraints.HORIZONTAL, new Insets(2, 2, 2, 2), 0, 0);
		pnNovoNo.add(txtNomeNo, c);
		
		c = new GridBagConstraints(0, 2, 1, 1, 60, 100, GridBagConstraints.WEST, GridBagConstraints.HORIZONTAL, new Insets(2, 2, 2, 2), 0, 0);
		pnNovoNo.add(btnCriarNo, c);
		
		c = new GridBagConstraints(1, 2, 1, 1, 60, 100, GridBagConstraints.WEST, GridBagConstraints.HORIZONTAL, new Insets(2, 2, 2, 2), 0, 0);
		pnNovoNo.add(btnRemoverNo, c);
		
		cbDe = new JComboBox(new ModeloCombo());
		cbAte = new JComboBox(new ModeloCombo());
		
		txtPeso = new JTextField();
		
		btnCriarAresta = new JButton("Criar");
		btnCriarAresta.setMnemonic('i');
		btnCriarAresta.setToolTipText("Cria uma aresta do n� X ao Y com peso Z");
		btnCriarAresta.addActionListener(ouvinte);
		
		btnRemoverAresta = new JButton("Remover");
		btnRemoverAresta.setMnemonic('m');
		btnRemoverAresta.setToolTipText("Remover a aresta do n� X ao Y");
		btnRemoverAresta.addActionListener(ouvinte);
		
		c = new GridBagConstraints(0, 0, 1, 1, 50, 100, GridBagConstraints.WEST, GridBagConstraints.HORIZONTAL, new Insets(2, 2, 2, 2), 0, 0);
		pnAresta.add(cbDe, c);
		
		c = new GridBagConstraints(1, 0, 1, 1, 50, 100, GridBagConstraints.WEST, GridBagConstraints.HORIZONTAL, new Insets(2, 2, 2, 2), 0, 0);
		pnAresta.add(cbAte, c);
		
		c = new GridBagConstraints(0, 1, 2, 1, 0, 100, GridBagConstraints.WEST, GridBagConstraints.HORIZONTAL, new Insets(2, 2, 2, 2), 0, 0);
		pnAresta.add(txtPeso, c);
		
		c = new GridBagConstraints(0, 2, 1, 1, 50, 100, GridBagConstraints.WEST, GridBagConstraints.HORIZONTAL, new Insets(2, 2, 2, 2), 0, 0);
		pnAresta.add(btnCriarAresta, c);
		
		c = new GridBagConstraints(1, 2, 1, 1, 50, 100, GridBagConstraints.WEST, GridBagConstraints.HORIZONTAL, new Insets(2, 2, 2, 2), 0, 0);
		pnAresta.add(btnRemoverAresta, c);
		
		btnCalcular = new JButton("Calcular o menor caminho");
		btnCalcular.setMnemonic('a');
		btnCalcular.setToolTipText("Mostra o menor caminho entre os n�s selecionados");
		btnCalcular.addActionListener(ouvinte);
		
		txtLog = new JEditorPane();
		txtLog.setContentType("text/html");
		txtLog.setEditorKit(new HTMLEditorKit());
		txtLog.setEditable(false);
		txtLog.setPreferredSize(new Dimension(350, 100));
		
		pnLog.add(new JScrollPane(txtLog));
		
		pnNorth.setLayout(new GridBagLayout());
		
		c = new GridBagConstraints(0, 0, 1, 1, 50, 100, GridBagConstraints.WEST, GridBagConstraints.BOTH, new Insets(2, 2, 2, 2), 0, 0);
		pnNorth.add(pnNovoNo, c);
		
		c = new GridBagConstraints(1, 0, 1, 1, 50, 100, GridBagConstraints.WEST, GridBagConstraints.BOTH, new Insets(2, 2, 2, 2), 0, 0);
		pnNorth.add(pnAresta, c);
		
		c = new GridBagConstraints(0, 1, 2, 1, 0, 0, GridBagConstraints.EAST, GridBagConstraints.HORIZONTAL, new Insets(5, 5, 5, 5), 0, 0);
		pnNorth.add(btnCalcular, c);
		
		pnPainels.add(pnNorth, BorderLayout.NORTH);
		
		pnPainels.add(pnLog, BorderLayout.CENTER);
		
		contentPane.add(pnPainels, BorderLayout.CENTER);
		
		btnSobre = new JButton("Sobre");
		btnSobre.setMnemonic('o');
		btnSobre.addActionListener(ouvinte);
		
		JPanel pnRodape = new JPanel();
		pnRodape.setLayout(new FlowLayout(FlowLayout.RIGHT));
		
		btnSair = new JButton("Sair");
		btnSair.setMnemonic('S');
		btnSair.addActionListener(ouvinte);
		
		pnRodape.add(btnSobre);
		pnRodape.add(btnSair);
		
		contentPane.add(pnRodape, BorderLayout.SOUTH);
		
		this.pack();
	}
	
	@SuppressWarnings("unchecked")
	public boolean existe(Vector collection, Object anItem) {
		return collection.indexOf(anItem) != -1;
	}
	
	@SuppressWarnings("unchecked")
	public boolean adicionar(Vector collection, Object obj) {
		if (!existe(collection, obj)) {
			collection.add(obj);
			
			return true;
		}
		
		// N� j� existe
		return false;
	}
	
	@SuppressWarnings("unchecked")
	public boolean remover(Vector collection, Object obj){
		if (existe(collection, obj)) {
			collection.remove(obj);
			
			cbDe.setSelectedIndex(-1);
			cbAte.setSelectedIndex(-1);
			
			return true;
		}
		
		// N� n�o existe
		return false;
	}
	
	class ModeloCombo implements ComboBoxModel {
		private int selecionado = -1;
		
		public void setSelectedItem(Object anItem) {
			selecionado = nos.indexOf(anItem);
		}
		
		public Object getSelectedItem() {
			if (selecionado != -1)
				return nos.get(selecionado);
			
			return null;
		}
		
		public int getSize() {
			return nos.size();
		}
		
		public Object getElementAt(int index) {
			return nos.elementAt(index);
		}
		
		public void addListDataListener(ListDataListener l) {
		}
		
		public void removeListDataListener(ListDataListener l) {
		}
	}
	
	public void atualizarArestas() {
		arestas.clear();
		
		for (int i = 0; i < nos.size(); i++) {
			No no = (No)nos.elementAt(i);
			
			arestas.addAll(no.getArestas());
		}
	}
	
	// Manipula��o dos n�s e arestas
	class ButtonListener implements ActionListener {
		public void appendLog(String color, String text) {
			log.append("<font color=\"" + color + "\">" + text + "</font><br>");
			txtLog.setText(log.toString());
		}
		
		public void actionPerformed(ActionEvent e) {
			Object obj = e.getSource();
			
			if (obj == btnCriarNo) {
				if (txtNomeNo.getText().length() > 0) {
					No no = new No(txtNomeNo.getText());
					
					// Verifica se o n� j� existe
					if (adicionar(nos, no)) {
						this.appendLog("green", "N� \"" + no.getNome() + "\" criado.");
						
						// Atualiza o visual dos controles
						cbDe.updateUI();
						cbAte.updateUI();
					}
					else
						this.appendLog("red", "N� \"" + no.getNome() + "\" j� existe.");
				}
				else
					this.appendLog("red", "Nome de n� inv�lido.");
			}
			
			if (obj == btnRemoverNo) {
				if (txtNomeNo.getText().length() > 0) {
					No no = new No(txtNomeNo.getText());
					
					int i = nos.indexOf(no);
					
					if (i != -1) {
						no = (No)nos.elementAt(i);
						no.removerNo();
					}
					
					if (remover(nos, no)) {
						this.appendLog("green", "N� \"" + no.getNome() + "\" removido.");
						
						atualizarArestas();
						
						// Atualiza o visual dos controles
						cbDe.updateUI();
						cbAte.updateUI();
					}
					else
						this.appendLog("red", "N� \"" + no.getNome() + "\" n�o encontrado.");
				}
				else
					this.appendLog("red", "Nome de n� inv�lido.");
			}
			
			if (obj == btnCriarAresta) {
				No de = (No)cbDe.getSelectedItem();
				No ate = (No)cbAte.getSelectedItem();
				
				if (de == null || ate == null || txtPeso.getText().length() == 0)
					this.appendLog("red", "Selecione n�s v�lidos e digite um peso.");
				else {
					int peso;
					
					try {
						peso = Integer.parseInt(txtPeso.getText());
					}
					catch (Exception exc) {
						this.appendLog("red", "Digite um peso v�lido.");
						return;
					}
					
					if (peso < 0) {
						this.appendLog("red", "Digite um peso v�lido.");
						return;
					}
					
					if (de.compareTo(ate) != 0) {
						Aresta aresta = new Aresta(de, ate, peso);
						
						// Verifica se o n� j� existe
						if (adicionar(arestas, aresta)) {
							this.appendLog("green", "Aresta \"" + aresta + "\" criada.");
							
							// Atualiza o visual dos controles
							cbDe.updateUI();
							cbAte.updateUI();
						}
						else
							this.appendLog("red", "Aresta j� existe.");
					}
					else
						this.appendLog("red", "N�s de origem e destino devem ser diferentes.");
				}
			}
			
			if (obj == btnRemoverAresta) {
				No de = (No)cbDe.getSelectedItem();
				No ate = (No)cbAte.getSelectedItem();
				Aresta aresta = new Aresta(de, ate, 0);
				
				if (de == null || ate == null)
					this.appendLog("red", "Selecione n�s v�lidos e digite um peso.");
				else {
					if (de.compareTo(ate) != 0) {
						if (remover(arestas, aresta)) {
							this.appendLog("green", "Aresta removida.");
							aresta.removerAresta();
							
							// Atualiza o visual dos controles
							cbDe.updateUI();
							cbAte.updateUI();
						}
						else
							this.appendLog("red", "Aresta n�o encontrada.");
					}
					else
						this.appendLog("red", "N�s de origem e destino devem ser diferentes.");
				}
			}
			
			if (obj == btnCalcular) {
				No[] nos = new No[MainWindow.this.nos.size()];
				
				MainWindow.this.nos.toArray(nos);
				
				Caminho caminho = new Caminho(nos);
				
				No origem = (No)cbDe.getSelectedItem();
				No destino = (No)cbAte.getSelectedItem();
				
				No[] menor = caminho.menorCaminho(origem, destino);
				
				String text = "O menor caminho entre \"" + origem.getNome() + "\" e \"" + destino.getNome() + "\" �: ";
				
				if (menor != null) {
					int count = 0;
					for (int i = 0; i < menor.length; i++) {
						if (menor[i] != null) {
							count++;
							
							if (i > 0)
								text += ", ";
							
							text += menor[i];
						}
					}
					
					text += ".";
					
					if (count == 1 && menor[0].getD() == Caminho.INFINITY)
						text = "N�o existe caminho de \"" + origem + "\" at� \"" + destino + "\".";
					
					appendLog("blue", text);
				}
				else
					appendLog("red", "N�o existem n�s vizinhos � origem.");
			}
			
			if (obj == btnSobre) {
				JOptionPane.showMessageDialog(MainWindow.this, "Autor: Daniel F. Martins\r\nFaculdade Gennari & Peartree\r\nRedes de Computadores", "Informa��es", JOptionPane.INFORMATION_MESSAGE);
			}
			
			if (obj == btnSair) {
				System.exit(0);
			}
		}
	}
}
