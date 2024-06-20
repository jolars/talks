using DataFrames
using Plots
using Plots.PlotMeasures
using LaTeXStrings
using JSON
using ProjectRoot
using Plots
using ColorSchemes
using PlotThemes
using PythonPlot: matplotlib

function set_plot_defaults(backend="pyplot")
  # theme(:wong2)
  default(framestyle=:box, label=nothing, tick_direction=:out, palette=:tableau_10)
  if backend == "gr"
    gr()
  else
    default(
      guidefontsize=10,
      titlefontsize=10,
      background_color_outside=:transparent,
      legend_background_color=:transparent,
      thickness_scaling=0.9,
      grid=false,
    )
    pythonplot()
    matplotlib.rcParams["text.usetex"] = true
    matplotlib.rcParams["font.family"] = "serif"
    # matplotlib.rcParams["font.size"] = 9
    matplotlib.rcParams["lines.markersize"] = 3
    matplotlib.rcParams["text.latex.preamble"] = "\\usepackage{mathtools}\\usepackage[ebgaramond,textscale=0,semibold,vvarbb,amsthm]{newtx}\\usepackage{bm}"
  end
end

function delta_palette(ind)
  return ColorSchemes.Johnson[ind]'
end

set_plot_defaults();

json_data = JSON.parsefile(@projectroot("data", "realdata_paths.json"));
df = DataFrame(json_data);
df = subset(df, :dataset => d -> d .!= "housing");
df_flat = DataFrames.flatten(df, [:betas]);

plots = []

n_rows = length(unique(df.normalization))
n_cols = length(unique(df.dataset))


for (i, d) in enumerate(groupby(df, :normalization))
  for (j, dd) in enumerate(groupby(d, :dataset))
    normalization = unique(dd.normalization)[1]
    dataset = unique(dd.dataset)[1]

    betas = Float64.(mapreduce(permutedims, vcat, dd.betas[1]))'

    normalization =
      replace(normalization, "std" => "Standardization", "max_abs" => "Max--Abs")

    n_choose = 70

    betas = betas[:, 1:n_choose]

    first_ten = findfirst(dropdims(sum(betas .!= 0, dims=1) .>= 5, dims=1))
    var_ind = findall(Array(betas[:, first_ten]) .!= 0)

    coefs = betas ./ maximum(abs.(betas))

    n_var = size(coefs, 1)
    n_lambda = size(coefs, 2)
    x_var = 1:n_lambda

    var_grey = findall(dropdims(sum(betas .!= 0, dims=2) .> 0, dims=2))
    grey_vars = setdiff(var_grey, var_ind)

    xformatter = i == n_rows ? :auto : _ -> ""

    p = plot(legend=false)

    for i in grey_vars
      plot!(Array(x_var), coefs[i, :], legend=false, color=:gray90)
    end

    yguideposition = if j == n_cols
      :right
    else
      :left
    end

    yguide = if j == 1
      L"\hat\beta / \max_j |\hat\beta_j| "
    elseif j == n_cols
      normalization
    else
      ""
    end

    yformatter = j == 1 ? :auto : _ -> ""

    for i in var_ind
      plot!(
        Array(x_var),
        coefs[i, :],
        color=i,
        legend=false,
        xformatter=xformatter,
        yformatter=yformatter,
        yguide=yguide,
        yguideposition=yguideposition,
        ylims=(-1.1, 1.1),
      )
    end

    if i == 1
      title!(dataset)
    elseif j == 2
      xlabel!("Step")
    end

    push!(plots, p)
  end
end

plot_output = plot(plots..., layout=(n_rows, n_cols), size=(460, 350), left_margin=3mm, bottom_margin=3mm)

file_path = @projectroot("figures", "realdata_paths.pdf")

savefig(plot_output, file_path)
