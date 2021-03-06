## Project start
# File List Check for External Data Requirements:
# security_financial_data.rda
# consolidated_financial_data.rda
# revenue_data_member_ticker.rda
# bonds_ald_scenario.rda
# equity_ald_scenario.rda
# masterdata_ownership_datastore.rda
# masterdata_debt_datastore.rda


# Obtains data, processes the portfolio and saves the files

####################
#### DATA FILES ####
####################
currencies <- get_and_clean_currency_data()

fund_data <- get_and_clean_fund_data()

fin_data <- get_and_clean_fin_data()

comp_fin_data <- get_and_clean_company_fin_data()

revenue_data <- get_and_clean_revenue_data()

# emissions_data <- get_and_clean_emissions_data()

####################
#### PORTFOLIOS ####
####################
portfolio <- read_and_process_portfolio(project_name,
                                        fin_data,
                                        fund_data,
                                        currencies, 
                                        grouping_variables)


portfolio <- add_revenue_split(has_revenue, portfolio, revenue_data)

# emissions_totals <- add_emissions_data(portfolio, emissions_data)

# create_sector_breakdown <- 

eq_portfolio <- create_portfolio_subset(portfolio, 
                                        "Equity", 
                                        comp_fin_data)

cb_portfolio <- create_portfolio_subset(portfolio, 
                                        "Bonds", 
                                        comp_fin_data)

portfolio_total <- add_portfolio_flags(portfolio)

portfolio_overview <- portfolio_summary(portfolio_total)

identify_missing_data(portfolio_total)

audit_file <- create_audit_file(portfolio_total, comp_fin_data)

create_audit_chart(audit_file, proc_input_path)

################
#### SAVING ####
################

if(data_check(portfolio_total)){write_csv(portfolio_total, paste0(proc_input_path, "/", project_name, "_total_portfolio.csv"))}
if(data_check(eq_portfolio)){write_csv(eq_portfolio, paste0(proc_input_path, "/", project_name, "_equity_portfolio.csv"))}
if(data_check(cb_portfolio)){write_csv(cb_portfolio, paste0(proc_input_path, "/", project_name, "_bonds_portfolio.csv"))}
if(data_check(portfolio_overview)){write_csv(portfolio_overview, paste0(proc_input_path, "/", project_name, "_overview_portfolio.csv"))}
if(data_check(audit_file)){write_csv(audit_file, paste0(proc_input_path, "/", project_name,"_audit_file.csv"))}
# if(data_check(emissions_totals)){write_csv(emissions_totals, paste0(proc_input_path, "/", project_name, "_emissions.csv"))}



