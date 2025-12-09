# Requer o arquivo 'armazenamento.rb', que deve conter funções para carregar e salvar as tarefas
require_relative "armazenamento"

# Função para limpar a tela do terminal, variando entre sistemas operacionais
def limpar_tela
  system("clear") || system("cls")  # Limpa a tela no Linux/Mac (clear) ou no Windows (cls)
end

# Função que pausa a execução do programa até o usuário pressionar ENTER
def pausar
  puts "\nPressione ENTER para continuar..."  # Exibe a mensagem para o usuário
  STDIN.gets  # Aguarda o usuário pressionar ENTER
end

# Função para imprimir os detalhes de uma tarefa
def imprimir_tarefa(tarefa)
  # Verifica se a tarefa está concluída ou não
  status  = tarefa.concluida? ? "[X]" : "[ ]"
  
  # Verifica se a tarefa possui etiquetas e as adiciona à string de saída
  etiquetas = tarefa.etiquetas.any? ? " (#{tarefa.etiquetas.join(', ')})" : ""
  
  # Adiciona a data de prazo, se houver
  prazo   = tarefa.data_prazo ? " - prazo: #{tarefa.data_prazo}" : ""
  
  # Verifica se a tarefa está atrasada
  atraso  = tarefa.atrasada? ? " **ATRASADA**" : ""

  # Imprime os dados da tarefa formatados de forma legível
  puts "#{status} ##{tarefa.id} - #{tarefa.titulo}#{etiquetas}#{prazo}#{atraso}"
  
  # Se a tarefa tiver uma descrição não vazia, imprime a descrição
  if tarefa.descricao && !tarefa.descricao.strip.empty?
    puts "    #{tarefa.descricao}"
  end
end

# Função que lista todas as tarefas, ou um conjunto de tarefas filtradas
def listar_tarefas(lista_tarefas, conjunto = nil, titulo: "Todas as tarefas")
  limpar_tela  # Limpa a tela antes de listar as tarefas
  puts "=== #{titulo} ==="  # Imprime o título da seção de tarefas

  # Se um conjunto de tarefas for fornecido, usa ele, caso contrário, usa a lista completa
  tarefas = conjunto || lista_tarefas.to_a

  # Se não houver tarefas, imprime uma mensagem informando
  if tarefas.empty?
    puts "Nenhuma tarefa encontrada."
  else
    # Caso contrário, imprime cada tarefa usando a função 'imprimir_tarefa'
    tarefas.each { |t| imprimir_tarefa(t) }
  end

  pausar  # Pausa a execução para que o usuário veja as tarefas antes de continuar
end

# Função para adicionar uma nova tarefa à lista
def adicionar_tarefa(lista_tarefas)
  limpar_tela  # Limpa a tela antes de começar a criação da tarefa
  puts "=== Nova tarefa ==="  # Exibe o título para a criação de uma nova tarefa

  # Solicita os dados do usuário para a nova tarefa
  print "Título: "
  titulo = STDIN.gets.chomp  # Lê o título da tarefa

  print "Descrição (opcional): "
  descricao = STDIN.gets.chomp  # Lê a descrição (pode ser vazia)

  print "Prazo (AAAA-MM-DD) ou vazio: "
  data_prazo = STDIN.gets.chomp  # Lê o prazo de conclusão (pode ser vazio)
  data_prazo = nil if data_prazo.strip.empty?  # Se o usuário não informar o prazo, torna-o nulo

  # Solicita as etiquetas da tarefa, separadas por vírgula
  print "Etiquetas separadas por vírgula (ex: faculdade,prog) ou vazio: "
  entrada_etiquetas = STDIN.gets.chomp  # Lê as etiquetas
  etiquetas = entrada_etiquetas
               .split(",")  # Separa as etiquetas por vírgula
               .map { |e| e.strip.to_sym }  # Remove espaços e converte para símbolo
               .reject(&:empty?)  # Remove etiquetas vazias

  # Cria a tarefa e a adiciona à lista de tarefas
  tarefa = lista_tarefas.adicionar(
    titulo:     titulo,
    descricao:  descricao,
    data_prazo: data_prazo,
    etiquetas:  etiquetas
  )

  puts "\nTarefa ##{tarefa.id} criada!"  # Confirma a criação da tarefa com o id
  pausar  # Pausa para o usuário confirmar
end

# Função para marcar uma tarefa como concluída
def marcar_como_concluida(lista_tarefas)
  limpar_tela  # Limpa a tela antes de marcar a tarefa como concluída
  puts "=== Marcar tarefa como concluída ==="  # Exibe o título para marcar a tarefa como concluída
  print "Informe o id da tarefa: "
  id = STDIN.gets.chomp.to_i  # Lê o ID da tarefa

  tarefa = lista_tarefas.buscar_por_id(id)  # Busca a tarefa pelo ID
  if tarefa
    tarefa.marcar_concluida!  # Marca a tarefa como concluída
    puts "Tarefa ##{id} marcada como concluída."  # Confirma a ação
  else
    puts "Tarefa não encontrada."  # Caso não encontre a tarefa
  end
  pausar  # Pausa a execução para o usuário ver o resultado
end

# Função para filtrar as tarefas por etiqueta
def filtrar_por_etiqueta(lista_tarefas)
  limpar_tela  # Limpa a tela antes de começar o filtro
  puts "=== Filtrar por etiqueta ==="  # Exibe o título para filtrar tarefas por etiqueta
  print "Etiqueta (sem #): "
  etiqueta = STDIN.gets.chomp  # Lê a etiqueta para filtrar

  # Filtra as tarefas pela etiqueta informada
  tarefas = lista_tarefas.por_etiqueta(etiqueta)
  listar_tarefas(lista_tarefas, tarefas, titulo: "Tarefas com etiqueta :#{etiqueta}")  # Exibe as tarefas filtradas
end

# Função para atualizar uma tarefa existente
def atualizar_tarefa(lista_tarefas)
  limpar_tela
  puts "=== Atualizar tarefa ==="
  print "Informe o id da tarefa: "
  id = STDIN.gets.chomp.to_i  # Lê o ID da tarefa

  tarefa = lista_tarefas.buscar_por_id(id)
  if tarefa
    print "Novo título (atual: #{tarefa.titulo}): "
    titulo = STDIN.gets.chomp
    titulo = titulo.empty? ? tarefa.titulo : titulo

    print "Nova descrição (atual: #{tarefa.descricao}): "
    descricao = STDIN.gets.chomp
    descricao = descricao.empty? ? tarefa.descricao : descricao

    print "Novo prazo (atual: #{tarefa.data_prazo}): "
    data_prazo = STDIN.gets.chomp
    data_prazo = data_prazo.empty? ? tarefa.data_prazo : data_prazo

    print "Novas etiquetas (atual: #{tarefa.etiquetas.join(', ')}): "
    entrada_etiquetas = STDIN.gets.chomp
    etiquetas = entrada_etiquetas.empty? ? tarefa.etiquetas : entrada_etiquetas.split(",").map { |e| e.strip.to_sym }

    lista_tarefas.atualizar(id, titulo: titulo, descricao: descricao, data_prazo: data_prazo, etiquetas: etiquetas)

    puts "Tarefa ##{id} atualizada!"
  else
    puts "Tarefa não encontrada."
  end
  pausar
end

# Função para deletar uma tarefa
def deletar_tarefa(lista_tarefas)
  limpar_tela
  puts "=== Deletar tarefa ==="
  print "Informe o id da tarefa: "
  id = STDIN.gets.chomp.to_i  # Lê o ID da tarefa

  tarefa = lista_tarefas.deletar(id)
  if tarefa
    puts "Tarefa ##{id} deletada."
  else
    puts "Tarefa não encontrada."
  end
  pausar
end

# Carrega as tarefas previamente salvas
lista_tarefas = Armazenamento.carregar

# Loop principal do programa
loop do
  limpar_tela
  puts "=== Lista de Tarefas em Ruby ===" 
  puts "1 - Listar todas as tarefas"
  puts "2 - Listar apenas pendentes"
  puts "3 - Nova tarefa"
  puts "4 - Marcar como concluída"
  puts "5 - Filtrar por etiqueta"
  puts "6 - Listar tarefas concluídas"
  puts "7 - Atualizar tarefa"
  puts "8 - Deletar tarefa"
  puts "0 - Sair"
  print "\nEscolha uma opção: "

  opcao = STDIN.gets.chomp
  case opcao
  when "1"
    listar_tarefas(lista_tarefas)
  when "2"
    listar_tarefas(lista_tarefas, lista_tarefas.pendentes, titulo: "Tarefas pendentes")
  when "3"
    adicionar_tarefa(lista_tarefas)
  when "4"
    marcar_como_concluida(lista_tarefas) 
  when "5"
    filtrar_por_etiqueta(lista_tarefas) 
  when "6"
    listar_tarefas(lista_tarefas, lista_tarefas.concluidas, titulo: "Tarefas concluídas") 
  when "7"
    atualizar_tarefa(lista_tarefas)
  when "8"
    deletar_tarefa(lista_tarefas)
  when "0"
    break 
  else
    puts "Opção inválida!"
    pausar 
  end
  # Após cada ação, salva as tarefas no armazenamento
  Armazenamento.salvar(lista_tarefas)
end
