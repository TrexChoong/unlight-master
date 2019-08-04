package view.scene.game
{
    import flash.display.Sprite;
    import flash.display.DisplayObjectContainer;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.Duel;
    import model.Entrant;
    import model.events.BuffEvent;
    import view.image.game.BuffImage;
    import view.scene.BaseScene;
    import view.scene.common.CharaCardClip;

    /**
     * 状態異常クリップ
     *
     */

    public class BuffClip extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_POISON	:String = "毒状態です。移動の後にダメージを受けます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_POISON2	:String = "猛毒状態です。移動の後にダメージを受けます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_PARA	:String = "麻痺状態です。移動ポイントが０になります。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_ATKUP	:String = "攻撃力がアップしている状態です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_ATKDOWN	:String = "攻撃力がダウンしている状態です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_DEFUP	:String = "防御力がアップしている状態です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_DEFDOWN	:String = "防御力がダウンしている状態です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_BERSERK	:String = "凶暴化している状態です。全ての戦闘ダメージが２倍になります。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_NOMOVE	:String = "行動が出来ない状態です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_NOSAP	:String = "必殺技が使えない状態です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_SELFDES	:String = "自壊状態です。規定ターン経過後死亡します。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_ZOMBIE	:String = "不死状態です。戦闘で受けるダメージが０になります。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_TERROR	:String = "怯えている状態です。全ての戦闘ダメージが半分になります。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_MOVUP	:String = "移動力がアップしている状態です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_MOVDOWN	:String = "移動力がダウンしている状態です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_REGENE	:String = "再生状態です。移動の後に回復します。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_BIND	:String = "呪縛状態です。移動距離に応じてダメージを受けます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_CHAOS	:String = "混沌状態です。攻撃力と防御力が2倍になります。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_STIGMA	:String = "聖痕状態です。数値１につき攻撃力と防御力が１増加します。この状態異常は自然解除されません。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_STADOWN	:String = "能力低下状態です。数値１につき攻撃力と防御力が１減少します。この状態異常は自然解除されません。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_STICK	:String = "棍術状態です。ATKまたはDEFが上昇します。必殺技を発動後にモードが切り替ります。この状態異常は自然解除されません。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_CURSE	:String = "詛呪状態です。一度に与えることが出来るダメージ量が(10-付与数)に制限されます。この状態異常は自然解除されません。"
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_BLESS	:String = "臨界状態です。攻撃力と防御力が上昇。最大で3まで進行します。この状態異常は自然解除されません。"
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_ZOMBIE2	:String = "不死Ⅱ状態です。戦闘で受けるあらゆるダメージが０になります。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_CONTROL	:String = "操想状態です。規定ターン経過後死亡します。控えに下がった状態でも進行し、解除できません。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_TARGET	:String = "正鵠状態です。相手の特定スキルに対し、常に標的となります。この状態は自然解除されません。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_DARK	:String = "断絶状態です。HPを回復することが出来ません。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_DOLL	:String = "人形状態です。移動スキルを使用することが出来ません。";


        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_POISON	:String = "Poisoned status. Poisoned players take damage after the movement phase.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_POISON2	:String = "Poisoned status. Poisoned players take damage after the movement phase.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_PARA	:String = "Paralyzed status. Paralyzed players have 0 movement points and are unable to move.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_ATKUP	:String = "Increased attack power status.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_ATKDOWN	:String = "Decreased attack power status.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_DEFUP	:String = "Increased defensive power status.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_DEFDOWN	:String = "Decreased defensive power status.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_BERSERK	:String = "Berserk status! All combat damage is doubled.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_NOMOVE	:String = "You are unable to move.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_NOSAP	:String = "Sealed status. You cannot use special attacks.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_SELFDES	:String = "Disintegrating status. You will die after a number of turns have passed.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_ZOMBIE	:String = "Invulnerable status. All combat damage your receive is reduced to 0.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_TERROR	:String = "Afraid status. All combat damage to your opponent halved.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_MOVUP	:String = "Increased movement power status.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_MOVDOWN	:String = "Decreased movement power status.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_REGENE	:String = "Regenerating status. Recover HP even after moving.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_BIND	:String = "Cursed status. Take damage proportional to distance moved.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_CHAOS	:String = "Chaos status. Attack and defense power are doubled.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_STIGMA	:String = "Stigmata: attack and defense power increase in proportion to the power of the effect. This status effect will not go away naturally.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_STADOWN	:String = "Reduced abilities: attack and defense power are reduced by in proportion to the power of the effect. This status effect will not go away naturally.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_STICK	:String = "Bo staff skills: ATK or DEF increases depending on the mode. The mode will switch after your special attack. This status effect will not go away naturally.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_CURSE	:String = "Cursed: the amount of damage you can deal at once is limited to (10 - Number you give). This status effect will not go away naturally."
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_BLESS	:String = "Limit Break: ATK and DEF increases. Up to 3. This status effect will not go away naturally."
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_ZOMBIE2	:String = "Invulnerable II status. All damage taken during the battle is reduced to 0.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_CONTROL	:String = "Curse of Death. Character dies after a designated number of turns. This status persists even if in reserve, cannot be lifted.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_TARGET	:String = "Bullseye status Make the opponent's special skills the target. This status will not be removed by itself.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_DARK	:String = "Sever status, cannot recover HP.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_DOLL	:String = "You are a doll now, you cannot move.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_POISON	:String = "中毒狀態。移動時會造成傷害。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_POISON2	:String = "猛毒狀態。移動時會造成傷害。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_PARA	:String = "麻痺狀態。移動值變為0。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_ATKUP	:String = "攻擊力提升的狀態。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_ATKDOWN	:String = "攻擊力下降的狀態。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_DEFUP	:String = "防禦力提升的狀態。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_DEFDOWN	:String = "防禦力下降的狀態。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_BERSERK	:String = "凶暴化的狀態。所有的戰鬥傷害變成2倍。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_NOMOVE	:String = "不能行動的狀態。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_NOSAP	:String = "不能使用必殺技的狀態。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_SELFDES	:String = "自毀狀態。在規定的回合後死亡。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_ZOMBIE	:String = "不死狀態。在戰鬥中受到的損傷變為0。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_TERROR	:String = "恐懼的狀態。所有的戰鬥傷害減半。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_MOVUP	:String = "移動力提升的狀態。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_MOVDOWN	:String = "移動力下降的狀態";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_REGENE	:String = "再生狀態。移動後恢復血量";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_BIND	:String = "咒縛狀態。依照移動距離受到該有的傷害。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_CHAOS	:String = "混沌狀態。攻擊力與防禦力2倍。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_STIGMA	:String = "聖痕狀態。數值每增加1就會增加1點攻擊力與防禦力。這個異常狀態不會自然解除。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_STADOWN	:String = "能力低下狀態。數值每增加1就會減少1點攻擊力與防禦力。這個異常狀態不會自然解除。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_STICK	:String = "棍術狀態。ATK或者DEF上升。在必殺技發動後後切換模式。這個異常狀態不會自然解除。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_CURSE	:String = "詛咒狀態。每次可以給予傷害的量被限制在(10-詛呪的數值)。這個異常狀態不會自然解除。"
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_BLESS	:String = "臨界狀態。攻擊力跟防禦力上升。最大到3。此異常狀態不會自然解除。"
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_ZOMBIE2	:String = "不死II狀態。在戰鬥中所受到的全部傷害都變為0。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_CONTROL	:String = "操想狀態。在規定回合數後死亡。在待機狀態下也持續此狀態，無法解除。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_TARGET	:String = "標靶狀態。總是會成為對手特定技能的對象。這個狀態不會自然解除。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_DARK	:String = "斷絕狀態。無法回復HP。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_DOLL	:String = "傀儡狀態。無法使用移動技能。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_POISON	:String = "中毒状态。移动后将受伤。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_POISON2	:String = "猛毒状态。移动时会造成伤害。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_PARA	:String = "麻痹状态。移动点数将变为0。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_ATKUP	:String = "攻击力正在提升的状态。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_ATKDOWN	:String = "攻击力正在下降的状态。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_DEFUP	:String = "防御力正在提升的状态。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_DEFDOWN	:String = "防御力正在下降的状态。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_BERSERK	:String = "残暴化状态。所有的战斗伤害的效果将提升至2倍。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_NOMOVE	:String = "无法行动的状态。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_NOSAP	:String = "无法使用必杀技的状态。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_SELFDES	:String = "自我瓦解状态。在规定回合结束后死亡。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_ZOMBIE	:String = "不死状态。在战斗中受到的伤害变为0。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_TERROR	:String = "恐惧状态。所有的战斗伤害效果减半。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_MOVUP	:String = "移动力正在提升的状态。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_MOVDOWN	:String = "移动力正在下降的状态。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_REGENE	:String = "重生状态。移动后恢复。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_BIND	:String = "咒语束缚的状态。移动距离不同，受到的伤害不同。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_CHAOS	:String = "混沌状态。攻击力与防御力将提升至2倍。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_STIGMA	:String = "圣痕状态。数值增加1，攻击力及防御力也将增加1。这种异常状态不会自然解除。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_STADOWN	:String = "能力降低状态。数值增加1，攻击力及防御力将降低1。这种状态异常不会自然解除。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_STICK	:String = "棒术状态。ATK或者DEF上升。启动必杀技后切换模式。这种异常状态不会自然解除。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_CURSE	:String = "诅咒状态。一次能够造成的伤害限制在（10-诅咒的数值）。这种状态异常不会自然解除。"
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_BLESS	:String = "临界状态。最大可增加到3。这种异常状态无法自然解除。"
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_ZOMBIE2	:String = "不死II状态。在战斗中所受到的全部伤害都变为0。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_CONTROL	:String = "操想状态。在规定回合数后死亡。在待机状态下也持续此状态，无法解除。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_TARGET	:String = "标靶状态。总是会成为对手特定技能的对象。这个状态无法自然解除。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_DARK	:String = "断绝状态。无法回复HP。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_DOLL	:String = "傀儡状态。无法使用移动技能。";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_POISON	:String = "독 상태입니다. 이동 후에 데미지가 발생합니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_POISON2	:String = "猛毒状態です。移動の後にダメージを受けます。";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_PARA	:String = "마비 상태 입니다. 이동 포인트가 0이 됩니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_ATKUP	:String = "공격력이 상승하여 있는 상태 입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_ATKDOWN	:String = "공격력이 내려가 있는 상태 입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_DEFUP	:String = "방어력이 상승하여 있는 상태 입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_DEFDOWN	:String = "방어력이 내려가 있는 상태 입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_BERSERK	:String = "흉폭화되어 있는 상태입니다. 모든 데미지가 2배가 됩니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_NOMOVE	:String = "행동을 할 수 없는 상태입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_NOSAP	:String = "필살기를 사용할 수 없는 상태입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_SELFDES	:String = "자괴 상태 입니다. 규정 턴 경과후 사망합니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_ZOMBIE	:String = "불사 상태 입니다. 전투에서 받는 데미지가 0이 됩니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_TERROR	:String = "겁에 질린 상태입니다. 모든 전투 데미지가 반으로 감소합니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_MOVUP	:String = "이동력이 업되어 있는 상태입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_MOVDOWN	:String = "이동력이 다운되어 있는 상태입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_REGENE	:String = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_BIND	:String = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_CHAOS	:String = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_STIGMA	:String = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_STADOWN	:String = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_STICK	:String = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_CURSE	:String = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_BLESS	:String = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_ZOMBIE2	:String = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_CONTROL	:String = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_TARGET	:String = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_DARK	:String = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_DOLL	:String = "";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_POISON	:String = "[Empoisonné] Vos HP diminueront après la Phase d'Action.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_POISON2	:String = "Vous êtes dangereusement empoisonné. Vous subissez les dommages après votre déplacement.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_PARA	:String = "[Paralysé] Vos points de déplacement seront de 0.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_ATKUP	:String = "Meilleure capacité d'Attaque";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_ATKDOWN	:String = "Perte de capacité d'Attaque";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_DEFUP	:String = "Meilleure capacité de Défense";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_DEFDOWN	:String = "Perte de capacité de Défense";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_BERSERK	:String = "[Berserk] Les dégâts infligés à votre adversaire sont doublés";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_NOMOVE	:String = "Vous ne pouvez entreprendre aucune action.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_NOSAP	:String = "[Scellé] Vous ne pouvez réaliser aucune Attaque Spéciale";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_SELFDES	:String = "[Suicide] Vous mourrez à la fin du Tour";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_ZOMBIE	:String = "[Immortel] Vous ne subirez aucun dégât";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_TERROR	:String = "[Crainte] Tout les dégâts infligés à votre adversaire sont diminués de moitié.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_MOVUP	:String = "Meilleure capacité de Déplacement";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_MOVDOWN	:String = "Perte de capacité de Déplacement";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_REGENE	:String = "Régénération. Vous vous régénérerez après votre Déplacement";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_BIND	:String = "Sortilège. ";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_CHAOS	:String = "Chaos. Vos capacités d'Attaque et de Défense sont doublées.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_STIGMA	:String = "Stigmates. Pour chaque stigmate, augmentez votre capacité d'Action et de Défense de 1. Ce changement de statut ne disparaîtra pas automatiquement.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_STADOWN	:String = "Votre puissance est limitée à ATK-1 et DEF-1. Cet état anormal ne disparaîtra pas automatiquement.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_STICK	:String = "Vous êtes en état [Bojutsu]. ATK+1 ou DEF+1. Changement de mode après l'attaque spéciale. Cet état anormal ne disparaîtra pas automatiquement.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_CURSE	:String = "VVous êtes sous l'emprise d'un [Maléfice]. Vous pouvez infligé des dommages limités à (10 - valeur numérique). Cet état anormal ne disparaîtra pas automatiquement."
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_BLESS	:String = "Votre état est [Critique]. Augmentez au maximum de 3. Cet état anormal ne disparaîtra pas automatiquement."
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_ZOMBIE2	:String = "Vous êtes [Immortel II]. vous ne avez eu aucun dégât.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_CONTROL	:String = "Vous êtes [Chaste]. Après le nombre de tours prévu, vous mourrez. Vous ne pouvez revenir en arrière.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_TARGET	:String = "Il s'agit de l'état [Cible]. Vous êtes la cible de votre adversaire, quelle que soit son attaque spéciale. Cet état ne disparaît pas automatiquement.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_DARK	:String = "Vous êtes en état [Extinction]. Vous ne pouvez renouveler vos HP.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_DOLL	:String = "Vous vous êtes transformé en Poupée. Vous ne pouvez utiliser vos fonctions de déplacement.";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_POISON	:String = "毒状態です。移動の後にダメージを受けます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_POISON2	:String = "猛毒状態です。移動の後にダメージを受けます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_PARA	:String = "麻痺状態です。移動ポイントが０になります。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_ATKUP	:String = "攻撃力がアップしている状態です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_ATKDOWN	:String = "攻撃力がダウンしている状態です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_DEFUP	:String = "防御力がアップしている状態です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_DEFDOWN	:String = "防御力がダウンしている状態です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_BERSERK	:String = "凶暴化している状態です。全ての戦闘ダメージが２倍になります。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_NOMOVE	:String = "行動が出来ない状態です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_NOSAP	:String = "必殺技が使えない状態です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_SELFDES	:String = "自壊状態です。規定ターン経過後死亡します。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_ZOMBIE	:String = "不死状態です。戦闘で受けるダメージが０になります。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_TERROR	:String = "怯えている状態です。全ての戦闘ダメージが半分になります。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_MOVUP	:String = "移動力がアップしている状態です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_MOVDOWN	:String = "移動力がダウンしている状態です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_REGENE	:String = "再生状態です。移動の後に回復します。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_BIND	:String = "呪縛状態です。移動距離に応じてダメージを受けます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_CHAOS	:String = "混沌状態です。攻撃力と防御力が2倍になります。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_STIGMA	:String = "聖痕状態です。数値１につき攻撃力と防御力が１増加します。この状態異常は自然解除されません。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_STADOWN	:String = "能力低下状態です。数値１につき攻撃力と防御力が１減少します。この状態異常は自然解除されません。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_STICK	:String = "棍術状態です。ATKまたはDEFが上昇します。必殺技を発動後にモードが切り替ります。この状態異常は自然解除されません。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_CURSE	:String = "";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_ZOMBIE2	:String = "不死Ⅱ状態です。戦闘で受けるあらゆるダメージが０になります。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_CONTROL	:String = "操想状態です。規定ターン経過後死亡します。控えに下がった状態でも進行し、解除できません。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_TARGET	:String = "正鵠状態です。相手の特定スキルに対し、常に標的となります。この状態は自然解除されません。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_DARK	:String = "断絶状態です。HPを回復することが出来ません。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_DOLL	:String = "人形状態です。移動スキルを使用することが出来ません。";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_POISON  :String = "สถานะติดพิษ จะได้รับบาดเจ็บหลังจากเคลื่อนที่";//"毒状態です。移動の後にダメージを受けます。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_POISON2	:String = ""; // 猛毒状態です。移動の後にダメージを受けます。
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_PARA    :String = "สถานะอัมพาต แต้มในการเคลื่อนย้ายเป็น 0";//"麻痺状態です。移動ポイントが０になります。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_ATKUP   :String = "สถานะพลังโจมตีเพิ่มขึ้น";//"攻撃力がアップしている状態です。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_ATKDOWN :String = "สถานะพลังโจมตีลดลง";//"攻撃力がダウンしている状態です。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_DEFUP   :String = "พลังป้องกันเพิ่มขึ้น";//"防御力がアップしている状態です。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_DEFDOWN :String = "พลังป้องกันลดลง";//"防御力がダウンしている状態です。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_BERSERK :String = "สถานะบ้าคลั่ง ค่าความเสียหายที่ทำได้ในการต่อสู้จะเพิ่มเป็น 2 เท่า";//"凶暴化している状態です。全ての戦闘ダメージが２倍になります。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_NOMOVE  :String = "ไม่สามารถขยับได้";//"行動が出来ない状態です。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_NOSAP   :String = "ไม่สามารถใช้ท่าไม้ตายได้";//"必殺技が使えない状態です。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_SELFDES :String = "สถานะสลายตัว หากผ่านเทิร์นที่กำหนดไปแล้วตัวละครจะเสียชีวิต";//"自壊状態です。規定ターン経過後死亡します。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_ZOMBIE  :String = "สถานะอมตะ อาการบาดเจ็บจากการต่อสู้จะเป็น 0";//"不死状態です。戦闘で受けるダメージが０になります。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_TERROR  :String = "สถานะตื่นตระหนก ค่าความเสียหายที่ทำได้ในการต่อสู้จะเหลือครึ่งเดียว";//"怯えている状態です。全ての戦闘ダメージが半分になります。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_MOVUP   :String = "พลังในการเคลื่อนที่เพิ่มขึ้น";//"移動力がアップしている状態です。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_MOVDOWN :String = "พลังในการเคลื่อนที่ลดลง";//"移動力がダウンしている状態です。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_REGENE  :String = "สถานะฟื้นคืน พลังจะฟื้นคืนหลัง Move Phase";//"再生状態です。移動の後に回復します。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_BIND    :String = "สถานะต้องสาป ความเสียหายที่จะได้รับขึ้นอยู่กับระยะห่าง";//"呪縛状態です。移動距離に応じてダメージを受けます。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_CHAOS   :String = "สถานะสับสน พลังโจมตีและพลังป้องกันเพิ่มขึ้นเป็น 2 เท่า";//"混沌状態です。攻撃力と防御力が2倍になります。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_STIGMA  :String = "สถานะแผลศักดิ์สิทธิ์ เมื่อมีค่าเป็น 1 จะเพิ่มพลังโจมตีและป้องกัน 1 แต้ม สถานะผิดปกตินี้จะไม่สามารถหายได้เอง";//"聖痕状態です。数値１につき攻撃力と防御力が１増加します。この状態異常は自然解除されません。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_STADOWN :String = "สถานะความสามารถลดลง พลังโจมตีและพลังป้องกันจะลดลง 1 แต้มต่อจำนวน 1 แต้ม สถานะผิดปกตินี้จะไม่หายไปเอง";//"能力低下状態です。数値１につき攻撃力と防御力が１減少します。この状態異常は自然解除されません。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_STICK   :String = "สถานะศาสตร์ไม้เท้า ATK หรือ DEF จะเพิ่มขึ้น จะเปลี่ยนโหมดพลังจากใช้ท่าไม้ตาย สถานะผิดปกตินี้จะไม่หายไปเอง";//"棍術状態です。ATKまたはDEFが上昇します。必殺技を発動後にモードが切り替ります。この状態異常は自然解除されません。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_CURSE   :String = "สภาวะคำสาป ความเสียหายที่จะได้รับต่อครั้ง(จำนวน10) สภาวะผิดปกติจะทำให้ไม่สามารถสู้ได้ตามปกติ"; // 詛呪状態です。一度に与えることが出来るダメージ量が(10-付与数)に制限されます。この状態異常は自然解除されません。
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_BLESS	:String = "" // "臨界状態です。最大で3まで増加します。この状態異常は自然解除されません。"
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_ZOMBIE2	:String = ""; // 不死Ⅱ状態です。戦闘で受けるあらゆるダメージが０になります。
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_CONTROL	:String = ""; // 操想状態です。規定ターン経過後死亡します。控えに下がった状態でも進行し、解除できません。
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_TARGET	:String = "正鵠状態です。相手の特定スキルに対し、常に標的となります。この状態は自然解除されません。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_DARK	:String = "断絶状態です。HPを回復することが出来ません。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_DOLL	:String = "人形状態です。移動スキルを使用することが出来ません。";


        // デュエルインスタンス
        private var _duel:Duel = Duel.instance;

        // 表示オブジェクト
        private var _buffImage:BuffImage = new BuffImage();

        // 変数
        private var _id:int;
        private var _value:int;
        private var _turn:int;
        private var _viewTurn:Boolean = true;

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["毒状態です。移動の後にダメージを受けます。"],
//                ["麻痺状態です。移動ポイントが０になります。"],
//                ["攻撃力がアップしている状態です。"],
//                ["攻撃力がダウンしている状態です。"],
//                ["防御力がアップしている状態です。"],
//                ["防御力がダウンしている状態です。"],
//                ["凶暴化している状態です。全ての戦闘ダメージが２倍になります。"],
//                ["行動が出来ない状態です。"],
//                ["必殺技が使えない状態です。"],
//                ["自壊状態です。規定ターン経過後死亡します。"],
//                ["不死状態です。戦闘で受けるダメージが０になります。"],
                [_TRANS_MSG_POISON],
                [_TRANS_MSG_PARA],
                [_TRANS_MSG_ATKUP],
                [_TRANS_MSG_ATKDOWN],
                [_TRANS_MSG_DEFUP],
                [_TRANS_MSG_DEFDOWN],
                [_TRANS_MSG_BERSERK],
                [_TRANS_MSG_NOMOVE],
                [_TRANS_MSG_NOSAP],
                [_TRANS_MSG_SELFDES],
                [_TRANS_MSG_ZOMBIE],
                [_TRANS_MSG_TERROR],
                [_TRANS_MSG_MOVUP],
                [_TRANS_MSG_MOVDOWN],
                [_TRANS_MSG_REGENE],
                [_TRANS_MSG_BIND],
                [_TRANS_MSG_CHAOS],
                [_TRANS_MSG_STIGMA],
                [_TRANS_MSG_STADOWN],
                [_TRANS_MSG_STICK],
                [_TRANS_MSG_CURSE],
                [_TRANS_MSG_BLESS],
                [_TRANS_MSG_ZOMBIE2],
                [_TRANS_MSG_POISON2],
                [_TRANS_MSG_CONTROL],
                [_TRANS_MSG_TARGET],
                [_TRANS_MSG_DARK],
                [_TRANS_MSG_DOLL],
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];

        /**
         * コンストラクタ
         *
         */
        public function BuffClip(i:int = 0, v:int = 0, t:int = 0, vt:Boolean = true)
        {
            _id = i;
            _value = v;
            _turn = t;
            _viewTurn = vt;
        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            _toolTipOwnerArray = [];
            _toolTipOwnerArray.push([0,this]);  //
        }

        //
        protected override function get helpTextArray():Array /* of String or Null */
        {
            return _helpTextArray;
        }

        protected override function get toolTipOwnerArray():Array /* of String or Null */
        {
            return _toolTipOwnerArray;
        }

        public override function init():void
        {
            _buffImage.atAnime(_id);
            _buffImage.atValue(_value);
            _buffImage.atTurn(_turn);
            _buffImage.setTurnVisible = _viewTurn;

            initilizeToolTipOwners();
            updateHelp(_id-1);

            addChild(_buffImage);
        }

        public override function final():void
        {
            removeChild(_buffImage);
        }

        // ターンが変化した時のアップデート
        public function updateTurn():void
        {
            // イメージに現在のターンを反映させる
            _buffImage.atTurn(_turn);
        }

        // 数値が変化した時のアップデート
        public function updateValue():void
        {
            // イメージに現在のターンを反映させる
            _buffImage.atValue(_value);
        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return new ShowThread(this, stage);
        }

        // 消去のスレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            return new HideThread(this);
        }

        public function get turn():int
        {
            return _turn;
        }

        public function set turn(t:int):void
        {
            _turn = t;
            updateTurn();
        }

        public function get no():int
        {
            return _id;
        }

        public function get value():int
        {
            return _value;
        }

        public function set value(v:int):void
        {
            _value = v;
            updateValue();
        }

        // レイド戦ボスの場合のY位置設定
        public function setYPos(y:int):void
        {
            _buffImage.x = -15;
            _buffImage.y = y;
        }

    }

}


import flash.display.Sprite;
import flash.display.DisplayObjectContainer;

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;

import view.scene.game.BuffClip;
import view.BaseShowThread;
import view.BaseHideThread;

import model.Duel;

// 基本的なShowスレッド
class ShowThread extends BaseShowThread
{

    public function ShowThread(bc:BuffClip, stage:DisplayObjectContainer)
    {
        super(bc, stage);
    }

    protected override function run():void
    {
        // デュエルの準備を待つ
        if (Duel.instance.inited == false)
        {
            Duel.instance.wait();
        }

        next(close);
    }
}

// 基本的なHideスレッド
class HideThread extends BaseHideThread
{
    public function HideThread(bc:BuffClip)
    {
        super(bc);
    }
}
