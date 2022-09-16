$:.unshift File.dirname(__FILE__)

require 'bundler/setup'
Bundler.require
require 'scratch/node/base_node'
require 'scratch/lexer'
require 'scratch/parser'
require 'scratch/evaluator'
