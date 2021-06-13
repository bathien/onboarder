In summary, my solution are:
- Add index constraint uniq in DB level and model to prevent duplication onboarder
- For Data in-consistentcy between 2 service I simply add a column called submitted_at which stored the time when we trigger Rails callback on Engage product. We only perform update onboarder when we get new version which subbmited_at later than our submmited at onboard product
