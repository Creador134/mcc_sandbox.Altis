class mcc_sandbox_moduleCover : Module_F
{
	category = "MCC";
	author = "shay_gman";
	displayName = "Settings (Cover)";
	icon = "\mcc_sandbox_mod\data\mccModule.paa";
	picture = "\mcc_sandbox_mod\data\mccModule.paa";
	vehicleClass = "Modules";
	function = "MCC_fnc_settingsCover";
	scope = 2;
	isGlobal = 1;
	
	class Arguments
	{
		class cover
		{
			displayName = "Cover System";
			description = "Allows player to pick out of cover automatically and vault/climb over obstecls";
			typeName = "NUMBER";
			class values
			{
				class Enabled
				{
					name = "Yes";
					value = 1;
					default = 1;
				};
				class Disabled
				{
					name = "No";
					value = 0;
				};
			};
		};
		
		class coverUI
		{
			displayName = "Cover System UI";
			description = "Show/hide cover UI";
			typeName = "NUMBER";
			class values
			{
				class Enabled
				{
					name = "Yes";
					value = 1;
					default = 1;
				};
				class Disabled
				{
					name = "No";
					value = 0;
				};
			};
		};
		
		class coverRecoil
		{
			displayName = "Cover System Recoil";
			description = "While shooting from behind cover players will suffer less recoil - aka weapon resting";
			typeName = "NUMBER";
			class values
			{
				class Enabled
				{
					name = "Yes";
					value = 1;
					default = 1;
				};
				class Disabled
				{
					name = "No";
					value = 0;
				};
			};
		};
		
		class coverVault
		{
			displayName = "Allow vault/climb";
			description = "While using cover players can climb over obstacles";
			typeName = "NUMBER";
			class values
			{
				class Enabled
				{
					name = "Yes";
					value = 1;
					default = 1;
				};
				class Disabled
				{
					name = "No";
					value = 0;
				};
			};
		}
	};
	
	class ModuleDescription: ModuleDescription
	{
		description = "Define MCC's cover settings";
	};
};