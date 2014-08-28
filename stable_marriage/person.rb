class Person

  def initialize(name, number, preference_list = [])
    @name = name
    @number = number
    @engaged_to = nil
    @preference_list = preference_list
    @proposals = []
  end

  attr_reader :number,:name, :proposals
  attr_accessor :engaged_to, :preference_list

  def to_s
    @name
  end

  def display
    puts "#{number} - #{name} - #{preference_list}"
  end

  def single?
    @engaged_to == nil
  end

  def break_up
    @engaged_to = nil
  end

  def engage(person)
    self.engaged_to = person
    person.engaged_to = self
  end

  def upgrade?(person)
    @preference_list.index(person) < @preference_list.index(@engaged_to)
  end

  def propose(person)
    puts "#{self} proposes to #{person}"
    @proposals << person
    person.proposal_response(self)
  end

  def proposal_response(person)
    if single?
      puts "#{self} is engaged with #{person}"
      engage(person)
    elsif upgrade?(person)
      puts "#{self} upgrades from #{engaged_to} to #{person}"
      @engaged_to.break_up
      engage(person)
    else
      puts "#{self} rejects #{person}"
    end
  end
end