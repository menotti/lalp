// A função main() é obrigatória em todo programa C.
void main()
{
  // Aqui foi necessário atribuir valores as variáveis a e b.
  int a = 0;
  int b = 1;
  int auxiliar = 0;
  int i = 0;
  #pragma out auxiliar
 
  for(i = 0; i < 32; i++)
  {
    auxiliar = a;
    b += a;
    a = b;
  }
}