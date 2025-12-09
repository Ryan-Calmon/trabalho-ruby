# lista_tarefas.rb
require_relative "tarefa"

class ListaTarefas
  include Enumerable

  def initialize(tarefas = [])
    @tarefas = tarefas
  end

  # permite: lista.each { |t| ... }
  def each(&bloco)
    @tarefas.each(&bloco)
  end

  def to_a
    @tarefas
  end

  def proximo_id
    (@tarefas.map(&:id).max || 0) + 1
  end

  def adicionar(titulo:, descricao: "", data_prazo: nil, etiquetas: [])
    tarefa = Tarefa.new(
      id:         proximo_id,
      titulo:     titulo,
      descricao:  descricao,
      data_prazo: data_prazo,
      etiquetas:  etiquetas
    )
    @tarefas << tarefa
    tarefa
  end

  def buscar_por_id(id)
    @tarefas.find { |t| t.id == id.to_i }
  end

  def pendentes
    select { |t| !t.concluida? }
  end

  def concluidas
    select(&:concluida?)
  end

  def por_etiqueta(etiqueta)
    etiqueta = etiqueta.to_sym
    select { |t| t.etiquetas.include?(etiqueta) }
  end

  # Novo método: Atualizar uma tarefa existente
  def atualizar(id, titulo:, descricao:, data_prazo:, etiquetas:)
    tarefa = buscar_por_id(id)
    if tarefa
      tarefa.titulo = titulo
      tarefa.descricao = descricao
      tarefa.data_prazo = data_prazo
      tarefa.etiquetas = etiquetas
    end
    tarefa
  end

  # Novo método: Deletar uma tarefa
  def deletar(id)
    tarefa = buscar_por_id(id)
    @tarefas.delete(tarefa) if tarefa
    tarefa
  end
end
