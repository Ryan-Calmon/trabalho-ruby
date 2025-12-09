require "yaml"
require_relative "lista_tarefas"

class Armazenamento
  ARQUIVO_PADRAO = "tarefas.yml"

  def self.carregar(arquivo = ARQUIVO_PADRAO)
    unless File.exist?(arquivo)
      return ListaTarefas.new
    end

    dados  = YAML.load_file(arquivo) || []
    tarefas = dados.map { |h| Tarefa.de_hash(h) }
    ListaTarefas.new(tarefas)
  rescue Psych::SyntaxError
    puts "Arquivo #{arquivo} corrompido. Iniciando lista vazia."
    ListaTarefas.new
  end

  def self.salvar(lista_tarefas, arquivo = ARQUIVO_PADRAO)
    dados = lista_tarefas.map(&:to_h)
    File.write(arquivo, YAML.dump(dados))
  end
end
