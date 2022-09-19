$:.unshift File.dirname(__FILE__)

require 'bundler/setup'
Bundler.require
require 'wyrm/node/base_node'
require 'wyrm/lexer'
require 'wyrm/parser'
require 'wyrm/evaluator'
