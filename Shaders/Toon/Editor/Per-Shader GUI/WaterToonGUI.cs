//created for Kortana's Water Toon v1.0
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class WaterToonEditor : ShaderGUI
{
	private static class Styles
	{
		//sections
		public static GUIContent MainSection = new GUIContent("Main", "Main Texture and Normals");
		public static GUIContent FoamSection = new GUIContent("Foam Options", "Options for foam.");
		public static GUIContent SeaSideSection = new GUIContent("Sea Side Options", "Depth settings");
		public static GUIContent MiscSection = new GUIContent("Miscellaneous", "Other Options that don't require a section");
		//public static GUIContent CreditsSection = new GUIContent("Credits", "");
		
		//Main
		public static GUIContent Color1 = new GUIContent("Water Color","Main Color");
		public static GUIContent Color2 = new GUIContent("Water Color (Secondary)","2nd Color");
		public static GUIContent Specular = new GUIContent("Specular","Sun Reflectiveness");
		public static GUIContent Normal = new GUIContent("Normal","Normals");
		public static GUIContent NormalInt = new GUIContent("Normal Intensity","Normal Intensity");
		public static GUIContent WaveSpeed = new GUIContent("Wave Speed"," x1y1x2y2");
		public static GUIContent WaveSpeedSm = new GUIContent("Smaller Wave Speed","x1y1x2y2");
		
		//Foam
		public static GUIContent FoamColor = new GUIContent("Color","Foam Color");
		public static GUIContent FoamWWidth = new GUIContent("White Width","White color Width");
		public static GUIContent FoamTexture = new GUIContent("Texture","Foam Texture");
		public static GUIContent FoamWidth = new GUIContent("Width","Width of foam from land");
		public static GUIContent FoamOpacity = new GUIContent("Opacity","Foam Clearness");
		public static GUIContent FoamSpeed = new GUIContent("Speed","x1y1x2y2");
		public static GUIContent FoamMask = new GUIContent("Mask","Foam Mask");
		
		//Sea Side
		public static GUIContent OffOceanColor = new GUIContent("Distant Ocean Color","Distance Color");
		public static GUIContent OffOceanOpacity = new GUIContent("Distant Ocean Color Opacity","Distance Clearness");
		public static GUIContent OffOceanDepth = new GUIContent("Ocean Depth","Simulate Deepness");
		public static GUIContent SeaSideColor = new GUIContent("Color","");
		public static GUIContent SeaSideDeep = new GUIContent("Deepness","");
		public static GUIContent SeaSideDeepWidth = new GUIContent("Deepness Width","");
		public static GUIContent SeaSideWidth = new GUIContent("Width","");
		public static GUIContent SeaSideOpacity = new GUIContent("Opacity","");
		
		//Misc
		public static GUIContent HeightDisp = new GUIContent("Height Displacment","");
		public static GUIContent Refraction = new GUIContent("Refraction","");
		public static GUIContent NormalNone = new GUIContent("Normal None","Don't touch");
		public static GUIContent Step = new GUIContent("Posterize Step","");
		public static GUIContent HeightFactor = new GUIContent("Height Factor","");
		public static GUIContent Tesselation = new GUIContent("Tesselation","");
		public static GUIContent Cutoff = new GUIContent("Cutoff","Don't Touch");
	}
	
	GUIStyle m_sectionStyle;
	MaterialProperty m_Color1 = null;
	MaterialProperty m_Color2 = null;
	MaterialProperty m_Specular = null;
	MaterialProperty m_Normal = null;
	MaterialProperty m_NormalInt = null;
	MaterialProperty m_WaveSpeed = null;
	MaterialProperty m_WaveSpeedSm = null;
	
	MaterialProperty m_FoamColor = null;
	MaterialProperty m_FoamWWidth = null;
	MaterialProperty m_FoamTexture = null;
	MaterialProperty m_FoamWidth = null;
	MaterialProperty m_FoamOpacity = null;
	MaterialProperty m_FoamSpeed = null;
	MaterialProperty m_FoamMask = null;
	
	MaterialProperty m_OffOceanColor = null;
	MaterialProperty m_OffOceanOpacity = null;
	MaterialProperty m_OffOceanDepth = null;
	MaterialProperty m_SeaSideColor = null;
	MaterialProperty m_SeaSideDeep = null;
	MaterialProperty m_SeaSideDeepWidth = null;
	MaterialProperty m_SeaSideWidth = null;
	MaterialProperty m_SeaSideOpacity = null;
	
	MaterialProperty m_HeightDisp = null;
	MaterialProperty m_Refraction = null;
	MaterialProperty m_NormalNone = null;
	MaterialProperty m_Step = null;
	MaterialProperty m_HeightFactor = null;
	MaterialProperty m_Tesselation = null;
	MaterialProperty m_Cutoff = null;
	
	bool m_MainSection = true;
	bool m_FoamSection;
	bool m_SeaSideSection;
	bool m_MiscSection;
	bool m_Credits;
	bool m_ChangeLog /*= true*/;
	
	private void FindProperties(MaterialProperty[] props)
	{
		m_Color1 = FindProperty("_color_water_1", props);
		m_Color2 = FindProperty("_color_water_2", props);
		m_Specular = FindProperty("_Specular", props);
		m_Normal = FindProperty("_Normal", props);
		m_NormalInt = FindProperty("_NRMIntensity", props);
		m_WaveSpeed = FindProperty("_WaveSpeedx1y1x2y2", props);
		m_WaveSpeedSm = FindProperty("_WaveSmallSpeedx1y1x2y2", props);
		
		m_FoamColor = FindProperty("_color_foam", props);
		m_FoamWWidth = FindProperty("_foam_white_width", props);
		m_FoamTexture = FindProperty("_Foam_Albedo", props);
		m_FoamWidth = FindProperty("_Foam_width", props);
		m_FoamOpacity = FindProperty("_opacity_foam_width", props);
		m_FoamSpeed = FindProperty("_FoamSpeed_x1y1x2y2", props);
		m_FoamMask = FindProperty("_mask_foam", props);
		
		m_OffOceanColor = FindProperty("_offoceancolor", props);
		m_OffOceanOpacity = FindProperty("_Opacityofftheocean", props);
		m_OffOceanDepth = FindProperty("_off_ocean_depth", props);
		m_SeaSideColor = FindProperty("_SeaSide_color", props);
		m_SeaSideDeep = FindProperty("_SeaSidedeep", props);
		m_SeaSideDeepWidth = FindProperty("_SeaSide_deep_width", props);
		m_SeaSideWidth = FindProperty("_SeaSide_width", props);
		m_SeaSideOpacity = FindProperty("_OpacitySeaside", props);
		
		m_HeightDisp = FindProperty("_Height_Disp", props);
		m_Refraction = FindProperty("_Refraction", props);
		m_NormalNone = FindProperty("_NRM_None", props);
		m_Step = FindProperty("_Posterize_step", props);
		m_HeightFactor = FindProperty("_Height_factor", props);
		m_Tesselation = FindProperty("_Tesselation", props);
		m_Cutoff = FindProperty("_Cutoff", props);
	}
	
	private void SetupStyle()
    {
        m_sectionStyle = new GUIStyle(EditorStyles.boldLabel);
        m_sectionStyle.alignment = TextAnchor.MiddleCenter;
    }
	
	private void ToggleDefine(Material mat, string define, bool state)
    {
        if (state)
        {
            mat.EnableKeyword(define);
        }
        else
        {
            mat.DisableKeyword(define);
        }
    }
    void ToggleDefines(Material mat)
    {
    }

    void LoadDefaults(Material mat)
    {
    }

    void DrawHeader(ref bool enabled, ref bool options, GUIContent name)
    {
        var r = EditorGUILayout.BeginHorizontal("box");
        enabled = EditorGUILayout.Toggle(enabled, EditorStyles.radioButton, GUILayout.MaxWidth(15.0f));
        options = GUI.Toggle(r, options, GUIContent.none, new GUIStyle());
        EditorGUILayout.LabelField(name, m_sectionStyle);
        EditorGUILayout.EndHorizontal();
    }
	
	void DrawMasterLabel()
    {
        GUIStyle style = new GUIStyle(GUI.skin.label);
        style.richText = true;
        style.alignment = TextAnchor.MiddleCenter;

        EditorGUILayout.LabelField("<size=20><color=#00ffaa>Water Toon Shader <size=15>v1.0</size></color></size>", style, GUILayout.MinHeight(24));
		EditorGUILayout.Space();
    }
	
	void DrawBottomLabel()
    {
        GUIStyle style = new GUIStyle(GUI.skin.label);
        style.richText = true;
		
		EditorGUILayout.LabelField("GUI: <color=#e029b8>PoiyomiToon ~v2.3</color>, ShurikenModule", style, GUILayout.MinHeight(15));
		EditorGUILayout.LabelField("Shader Editor: <color=#e09429>Amplify Shader Editor</color>", style, GUILayout.MinHeight(15));
            if (GUILayout.Button("Available at the Unity Asset Store"))
            {
                Application.OpenURL("http://u3d.as/y3X ");
            }
			
		ExtraSpace();
		
        style.alignment = TextAnchor.MiddleCenter;

        EditorGUILayout.LabelField("<size=15><color=#ffffff>Made by</color> <color=#00ffaa>KortyBoi</color></size><size=10><color=#29abe0>#0001</color></size>", style, GUILayout.MinHeight(20));
		
		EditorGUILayout.Space();
		GUILayout.BeginHorizontal();
		
			GUI.backgroundColor = new Color32(0, 255, 170, 125);
            if (GUILayout.Button("My Website"))
            {
                Application.OpenURL("https://kortyboi.com/");
            }
			
			GUI.backgroundColor = new Color32(41, 171, 224, 125);
            if (GUILayout.Button("Donate"))
            {
                Application.OpenURL("https://ko-fi.com/kortyboi");
            }
			
            GUILayout.EndHorizontal();
    }
	
	void DrawChangeLog()
	{
		GUIStyle style = new GUIStyle(GUI.skin.label);
        style.richText = true;
        style.alignment = TextAnchor.MiddleLeft;
		
		EditorGUILayout.LabelField("<size=13.5><color=red><b>v1.0</b></color></size>", style, GUILayout.MinHeight(10));
		EditorGUILayout.LabelField(" <size=10> <color=red> - Initial Release</color></size>", style, GUILayout.MinHeight(10));
		/*
		EditorGUILayout.LabelField("<size=13.5><color=red><b>v </b></color></size>", style, GUILayout.MinHeight(10));
		EditorGUILayout.LabelField(" <size=10> <color=red> - </color></size>", style, GUILayout.MinHeight(10));
		*/
	}
	
	void ExtraSpace()
	{
		EditorGUILayout.Space();
		EditorGUILayout.Space();
		EditorGUILayout.Space();
	}
	
	public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
	{
		Material material = materialEditor.target as Material;
		
		FindProperties(props);
		SetupStyle();
		LoadDefaults(material);
		DrawMasterLabel();
		
		//Main
		m_MainSection = KortyShaderUI.Foldout("Main Section", m_MainSection);
        if (m_MainSection)
        {
            EditorGUILayout.Space();

			materialEditor.ShaderProperty(m_Color1, Styles.Color1);
			materialEditor.ShaderProperty(m_Color2, Styles.Color2);
			materialEditor.ShaderProperty(m_Specular, Styles.Specular);
			materialEditor.ShaderProperty(m_Normal, Styles.Normal);
			materialEditor.ShaderProperty(m_NormalInt, Styles.NormalInt);
			materialEditor.ShaderProperty(m_WaveSpeed, Styles.WaveSpeed);
			materialEditor.ShaderProperty(m_WaveSpeedSm, Styles.WaveSpeedSm);

            EditorGUILayout.Space();
        }
		
		//Foam
		m_FoamSection = KortyShaderUI.Foldout("Foam Section", m_FoamSection);
        if (m_FoamSection)
        {
            EditorGUILayout.Space();

			materialEditor.ShaderProperty(m_FoamColor, Styles.FoamColor);
			materialEditor.ShaderProperty(m_FoamTexture, Styles.FoamTexture);
			materialEditor.ShaderProperty(m_FoamWWidth, Styles.FoamWWidth);
			materialEditor.ShaderProperty(m_FoamWidth, Styles.FoamWidth);
			materialEditor.ShaderProperty(m_FoamOpacity, Styles.FoamOpacity);
			materialEditor.ShaderProperty(m_FoamSpeed, Styles.FoamSpeed);
			materialEditor.ShaderProperty(m_FoamMask, Styles.FoamMask);

            EditorGUILayout.Space();
        }
		
		//Sea Side
		m_SeaSideSection = KortyShaderUI.Foldout("Sea Side Section", m_SeaSideSection);
        if (m_SeaSideSection)
        {
            EditorGUILayout.Space();

            materialEditor.ShaderProperty(m_OffOceanColor, Styles.OffOceanColor);
			materialEditor.ShaderProperty(m_OffOceanOpacity, Styles.OffOceanOpacity);
			materialEditor.ShaderProperty(m_OffOceanDepth, Styles.OffOceanDepth);
			materialEditor.ShaderProperty(m_SeaSideColor, Styles.SeaSideColor);
			materialEditor.ShaderProperty(m_SeaSideDeep, Styles.SeaSideDeep);
			materialEditor.ShaderProperty(m_SeaSideDeepWidth, Styles.SeaSideDeepWidth);
			materialEditor.ShaderProperty(m_SeaSideWidth, Styles.SeaSideWidth);
			materialEditor.ShaderProperty(m_SeaSideOpacity, Styles.SeaSideOpacity);

            EditorGUILayout.Space();
        }
		
		//Misc
		m_MiscSection = KortyShaderUI.Foldout("Miscellaneous Section", m_MiscSection);
        if (m_MiscSection)
        {
            EditorGUILayout.Space();

            materialEditor.ShaderProperty(m_HeightDisp, Styles.HeightDisp);
			materialEditor.ShaderProperty(m_Refraction, Styles.Refraction);
			materialEditor.ShaderProperty(m_NormalNone, Styles.NormalNone);
			materialEditor.ShaderProperty(m_Step, Styles.Step);
			materialEditor.ShaderProperty(m_HeightFactor, Styles.HeightFactor);
			materialEditor.ShaderProperty(m_Tesselation, Styles.Tesselation);
			materialEditor.ShaderProperty(m_Cutoff, Styles.Cutoff);

            EditorGUILayout.Space();
        }
		
		ExtraSpace();
		
		//Change Log
		m_ChangeLog = KortyShaderUI.Foldout("Change Log", m_ChangeLog);
		if (m_ChangeLog)
		{
			EditorGUILayout.Space();

            DrawChangeLog();
			
            EditorGUILayout.Space();
        }
		
		//Credits
		m_Credits = KortyShaderUI.Foldout("Credits", m_Credits);
		if (m_Credits)
		{
			EditorGUILayout.Space();

            DrawBottomLabel();
			
            EditorGUILayout.Space();
        }
		
		ToggleDefines(material);
	}
}