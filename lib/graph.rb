# lib/graph.rb

require_relative './matrix'

module Graph
  class << self
    ROW = 0
    COL = 1
    INF = 999999999999999

    def build_graph(matrix, &block)
      graph = {}

      matrix.each_with_index do |row, x|
        row.each_with_index do |_, y|
          v = [x, y]
          graph[v] = {} if graph[v].nil?

          block.call(graph, matrix, x, y)
        end
      end

      graph
    end

    def shortest(graph, source, target)
      # graph
      # {
      #    vertex  => {
      #     neighbour => distance
      #   }
      # }

      dist = {}
      prev = {} # path
      q = [] # nodes whose distance to the starting point are discoved

      graph.keys.each do |vertex|
        dist[vertex] = INF
      end

      dist[source] = 0

      q.unshift(source)

      while !q.empty?
        # find next node that is closed to the starting node
        u = q.shift

        break if u == target

        graph[u].select { |nei, _| dist[nei] == INF }.each do |v, distance|
          alt = dist[u] + distance

          if alt < dist[v]
            dist[v] = alt
            prev[v] = u

            q << v
          end
        end

        q.sort_by! { |x| dist[x] }
      end

      [dist, prev]
    end
  end
end
