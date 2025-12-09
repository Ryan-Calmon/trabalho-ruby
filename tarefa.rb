# tarefa.rb
require 'date'

class Tarefa
  attr_reader :id, :data_criacao, :data_prazo
  attr_accessor :titulo, :descricao, :etiquetas, :data_conclusao

  def initialize(id:, titulo:, descricao: "", data_prazo: nil, etiquetas: [])
    @id = id
    @titulo = titulo
    @descricao = descricao
    self.data_prazo = data_prazo # Usa o nosso setter personalizado
    @etiquetas = etiquetas.map(&:to_sym)
    @data_criacao = Time.now
    @data_conclusao = nil
  end

  # Setter personalizado para data_prazo
  # Este método será chamado sempre que fizermos: tarefa.data_prazo = "algum valor"
  def data_prazo=(nova_data)
    @data_prazo = self.class.converter_data(nova_data)
  end

  def concluida?
    !@data_conclusao.nil?
  end

  def marcar_concluida!
    @data_conclusao = Time.now unless concluida?
  end

  def atrasada?
    return false if concluida? || @data_prazo.nil?
    @data_prazo < Date.today
  end

  def self.converter_data(data)
    # Se já for um objeto Date, retorna ele mesmo.
    return data if data.is_a?(Date)
    return nil if data.nil? || data.strip.empty?
    begin
      Date.parse(data)
    rescue ArgumentError
      nil
    end
  end

  def to_h
    {
      id: @id,
      titulo: @titulo,
      descricao: @descricao,
      data_prazo: @data_prazo&.iso8601, # Agora @data_prazo é garantidamente Date ou nil
      etiquetas: @etiquetas,
      data_conclusao: @data_conclusao
    }
  end

  def self.de_hash(hash)
    tarefa = new(
      id: hash[:id],
      titulo: hash[:titulo],
      descricao: hash[:descricao],
      data_prazo: hash[:data_prazo],
      etiquetas: hash[:etiquetas] || []
    )
    tarefa.data_conclusao = hash[:data_conclusao]
    tarefa
  end
end
